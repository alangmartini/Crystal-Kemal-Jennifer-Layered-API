require "../abstracts/services/**"
require "../entities/TravelPlans/RawTravelPlan.entity"

module TravelPlansService
    class Service < AbstractTravelPlanService
      @TravelPlanModel : TravelPlans.class
      @TravelStopsModel : RelTravelPlansTravelStops.class

      def initialize()
        @TravelPlanModel = TravelPlans
        @TravelStopsModel = RelTravelPlansTravelStops
      end

      def create_travel_plan(travel_stops_json : TravelStopsJSON)
        # TravelPlans only holds the travel plan id, with auto_increment
        created_travel_plans =
            @TravelPlanModel.create()
        
        if created_travel_plans.nil?
          raise ArgumentError
            .new("TravelStopsJSON is not valid") 
        end

        raw_travel_plan = RawTravelPlan
          .from_json(created_travel_plans.to_json)

        # With the id in hands, we can now create the travel stops
        travel_stops = create_travel_stops(
          travel_stops_json,
          raw_travel_plan.id
        )

        constructed_travel_plan = ConstructedTravelPlan.new(
          id: raw_travel_plan.id,
          travel_stops: travel_stops
        )

        constructed_travel_plan
      end

      # For each travel_stop supplied, create a new RelTravelPlansTravelStops
      # in DB, relationing it to the TravelPlan
      def create_travel_stops(
        travel_stops_json : TravelStopsJSON,
        id : Int32
        ) : Array(Int32)
        rel_travel_plans = [] of RelTravelPlansTravelStops

        travel_stops_json
          .travel_stops
          .each do |travel_stop|
            created_travel_stop = @TravelStopsModel
              .new({
                travel_plan_id: id,
                travel_stop_id: travel_stop
              })

            rel_travel_plans << created_travel_stop
          end

        @TravelStopsModel.import(rel_travel_plans)

        travel_stops = rel_travel_plans.map { |rel_travel_plan|
          rel_travel_plan.travel_stop_id }

        travel_stops  
      end

      def get_all_travel_plans(
        expand : Bool,
        optimise : Bool
      ) : Array( ConstructedTravelPlan) | Array()
        puts "oi"

      end
    end
end
