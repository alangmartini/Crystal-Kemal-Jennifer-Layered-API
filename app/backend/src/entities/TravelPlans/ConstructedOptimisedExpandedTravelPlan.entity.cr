class ConstructedExpandedTravelPlan
  property id : Int64
  property travel_stops : Array(ExpandedTravelStop)

  def initialize(@id : Int64, @travel_stops : Array(ExpandedTravelStop))
  end

  def to_json(json : JSON::Builder)
    json.object do
      json.field("id", @id)
      json.field("travel_stops", @travel_stops)
    end
  end
end