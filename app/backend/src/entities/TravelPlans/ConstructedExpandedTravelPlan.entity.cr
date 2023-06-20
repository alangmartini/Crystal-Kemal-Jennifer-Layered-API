class ConstructedExpandedTravelPlan
  property id : Int64
  property travel_stops : Array(TravelPlanLocation)

  def initialize(@id : Int64, @travel_stops : Array(TravelPlanLocation))
  end
end