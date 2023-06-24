require "json"

module TravelPlansRoute
  module Entities
    class TravelStopsJSON
      include JSON::Serializable

      @[JSON::Field]
      property travel_stops : Array(Int32)
    end
  end
end