class ConstructedTravelPlan
  property id : Int32
  property travel_stops : Array(Int32)

  def initialize(@id : Int32, @travel_stops : Array(Int32))
  end

  # Method for returning it as a response for requisitions
  def to_json(json : JSON::Builder)
    json.object do
      json.field("id", @id)
      json.field("travel_stops", @travel_stops)
    end
  end
end