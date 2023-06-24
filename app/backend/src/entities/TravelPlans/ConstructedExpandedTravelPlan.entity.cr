require "src/entities/TravelPlans/ExpandedTravelStop.entity"

class ConstructedExpandedTravelPlan
  property id : Int32
  property travel_stops : Array(ExpandedTravelStop)

  def initialize(@id : Int32, @travel_stops : Array(ExpandedTravelStop))
  end

  def to_json(json : JSON::Builder)
    json.object do
      json.field("id", @id)
      json.field("travel_stops", @travel_stops)
    end
  end
end