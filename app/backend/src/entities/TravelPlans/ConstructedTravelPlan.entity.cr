class ConstructedTravelPlan
  property id : Int64
  property travel_stops : Array(Int64)

  def initialize(@id : Int64, @travel_stops : Array(Int64))
  end

  # Method for returning it as a response for requisitions
  def to_json(json : JSON::Builder)
    json.object do
      json.field("id", @id)
      json.field("travel_stops", @travel_stops)
    end
  end
end