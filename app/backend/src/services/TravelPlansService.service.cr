require "../abstracts/services/**"
require "../entities/TravelPlans/RawTravelPlan.entity"

class TravelPlansService < AbstractTravelPlanService
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
    travel_stops = [] of Int32
    travel_stops_json
      .travel_stops
      .each do |travel_stop|
        created_travel_stop = @TravelStopsModel
          .create({
            travel_plan_id: raw_travel_plan.id,
            travel_stop_id: travel_stop
          })

        travel_stops << created_travel_stop.travel_stop_id
      end
    
    constructed_travel_plan = ConstructedTravelPlan.new(
      id: raw_travel_plan.id,
      travel_stops: travel_stops
    )

    constructed_travel_plan
  end

  def self.create_travel_stops(
    travel_stops : Array(Int32),
    id : Int32
    )

  end
end
