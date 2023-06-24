require "../../entities/TravelPlans/TravelStopsJSON.entity"

module TravelPlansRoute
  module TravelPlansService
    # Defined as abstract class for travel plans services
    abstract class AbstractTravelPlansService
      abstract def create_travel_plan(travel_stops_json : TravelStopsJSON)
    end
  end
end