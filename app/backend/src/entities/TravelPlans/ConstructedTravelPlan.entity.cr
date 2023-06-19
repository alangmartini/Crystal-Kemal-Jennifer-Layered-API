class ConstructedTravelPlan
  property id : Int64
  property travel_stops : Array(Int64)

  def initialize(@id : Int64, @travel_stops : Array(Int64))
  end
end