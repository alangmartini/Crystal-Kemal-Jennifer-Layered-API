require "../abstracts/services/**"

class TravelPlansService < AbstractTravelPlanService
  # @TravelPlanModel : AbstracTravelPlanModel

  def initialize()
    # @TravelPlanModel = TravelPlanModel.new
    # @TravelStopsModel = TravelStopsModel.new
  end

  def create_travel_plan(travel_stops : Array(Int32))
    # created_travel_plans :
    #   NamedTuple(id: Int32) 
    # = @TravelPlanModel.create_travel_plan(travel_stops)

    # @TravelPlanModel.create_travel_plan(travel_plan)
  end
end
