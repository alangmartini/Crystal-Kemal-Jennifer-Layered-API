require "json"

class TravelStopsJSON
  include JSON::Serializable

  @[JSON::Field]
  property travel_stops : Array(Int32)
end