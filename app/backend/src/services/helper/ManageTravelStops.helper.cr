require "src/entities/TravelPlans/ExpandedTravelStop.entity"

module TravelPlansRoute
  module TravelPlansService
    module Helper
        
      # Module for handling Travel Stops operations, like expading
      # creation or transformations.
      module ManageTravelStops
        alias SimplifiedLocation = RickAndMorty::Entities::SimplifiedLocation
        
        # Finds the correspondent locations from the travel stops
        # and returns them.
        def self.find_correspondent_locations(
          simplified_locations : Array(SimplifiedLocation),
          travel_stops : Array(Int32)
        )
          simplified_locations
            .select { |location| travel_stops
              .includes?(location.id) }
        end

        # Uses the information from `Location`
        # to expand a TravelStop into a `ExpandedTravelStop`.
        #
        # A expanded travel stop its just a travel_stop (Int32)
        # with details about the location.
        def self.get_expanded_travel_stops(
          simplified_locations : Array(SimplifiedLocation),
          travel_stops : Array(Int32)
        ) : Array(ExpandedTravelStop)
        
          new_travel_stops  = find_correspondent_locations(
            simplified_locations,
            travel_stops
          )
          
          new_travel_stops = new_travel_stops.map do |travel_stops|
            ExpandedTravelStop.new(
              id: travel_stops.id,
              name: travel_stops.name,
              dimension: travel_stops.dimension,
              type: travel_stops._type
            )
          end

          new_travel_stops
        end

        # Gets only the ids from the Locations, which
        # composes a simple travel stop.
        def self.get_unexpanded_travel_stops(
          simplified_locations : Array(SimplifiedLocation),
          travel_stops : Array(Int32)
        )
          self.find_correspondent_locations(
            simplified_locations,
            travel_stops
          ).map { |travel_stop| travel_stop.id }
        end

        # For each travel_stop supplied, create a new RelTravelPlansTravelStops
        # in DB, relationing it to the TravelPlan
        def self.create_travel_stops(
          travel_stops_json : TravelStopsJSON,
          id : Int32
          ) : Array(Int32)
          rel_travel_plans = [] of RelTravelPlansTravelStops

          travel_stops_json
            .travel_stops
            .each do |travel_stop|
              created_travel_stop = RelTravelPlansTravelStops
                .new({
                  travel_plan_id: id,
                  travel_stop_id: travel_stop
                })

              rel_travel_plans << created_travel_stop
            end

            RelTravelPlansTravelStops.import(rel_travel_plans)

          travel_stops = rel_travel_plans.map { |rel_travel_plan|
            rel_travel_plan.travel_stop_id }

          travel_stops  
        end
      end
    end
  end
end