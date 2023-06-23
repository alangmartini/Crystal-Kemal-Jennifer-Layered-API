require "../../entities/TravelPlans/TravelStopsJSON.entity"

module TravelPlansService
  abstract class AbstractTravelPlanService
    abstract def create_travel_plan(travel_stops_json : TravelStopsJSON)
  end
end