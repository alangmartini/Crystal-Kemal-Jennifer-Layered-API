require "../../entities/TravelPlans/RawTravelPlan.entity"
require "../../models/TravelPlans.model"
require "../../models/RelTravelPlansTravelStops.model"

module TravelPlansRoute
  module TravelPlansService
    module Helper
      # Contain operations necessary to retrieve `TravelPlans` from DB and construct
      # it to a `ConstructedTravelPlan` object
      #
      # A TravelPlan is stored in two trables, `TravelPlans` and `RelTravelPlansTravelStops`.
      # `TravelPlans` stores the id of the travel plan and `RelTravelPlansTravelStops` stores
      # the id of the travel plan and the id of the travel stop.
      #
      # Although it makes a little messier to make a TravelPlan, is compliant
      # to table normalization. Another option is use a NoSQL database.
      module GetAndConstructTravelPlans
        # Get all `TravelPlans` from DB and construct them to `RawTravelPlan` objects
        def self.get_all_raw_travel_plans_from_db() : Array(RawTravelPlan)
          # In Jennifer, .all only refers to a query,
          # needing thus .to_json to execute it.
          result = TravelPlans.all.to_json

          raw_travel_plans : Array(RawTravelPlan) = JSON
            .parse(result).as_a
            .map { |row| RawTravelPlan.from_json(row.to_json) }

          raw_travel_plans
        end
        
        # Get all `TravelStops` related to specific `TravelPlans` from DB
        def self.get_travel_stops_from_db(raw_travel_plan : RawTravelPlan)
          travel_stops_id =  RelTravelPlansTravelStops
              .all
              .where { _travel_plan_id == raw_travel_plan.id }
              .to_json(only: %w[travel_stop_id])

          travel_stops_ids : Array(Int32) = JSON
            .parse(travel_stops_id)
            .as_a.map { |row| row["travel_stop_id"].as_i }

          travel_stops_ids
        end

        # Construct RawTravelPlan and TravelStops to a `ConstructedTravelPlan`.
        def self.construct_travel_plans_from_raw(raw_travel_plans : Array(RawTravelPlan)) : Array(ConstructedTravelPlan)
          raw_travel_plans
            .map do |raw_travel_plan|
              travel_stops_ids = self.get_travel_stops_from_db(raw_travel_plan)
      
              ConstructedTravelPlan.new(
                id: raw_travel_plan.id,
                travel_stops: travel_stops_ids
              )
            end
        end

        # Join `RawTravelPlan` as its TravelStops and construct them to `ConstructedTravelPlan` objects
        def self.get_all_constructed_travel_plans() : Array(ConstructedTravelPlan)
          raw_travel_plans = self.get_all_raw_travel_plans_from_db()

          self.construct_travel_plans_from_raw(raw_travel_plans)
        end

        # Extract all unique ids from an array of `ConstructedTravelPlan`
        #
        # Used in `TravelStopsService::Service` to build and array
        # that will be served to fetch locations from Rick And Morty API.

        def self.get_all_unique_travel_stops_ids(
          construct_travel_plans : Array(ConstructedTravelPlan)
        ) : Array(Int32)
          travel_stops = [] of Int32
          construct_travel_plans
            .each { |a| a.travel_stops.each { |b| travel_stops << b } }

          travel_stops = travel_stops.uniq

          travel_stops
        end 
      end
    end
  end
end