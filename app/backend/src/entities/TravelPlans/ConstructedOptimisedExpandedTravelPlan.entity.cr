require "src/entities/TravelPlans/ExpandedTravelStop.entity"

module TravelPlansRoute
  module Entities
    # Structuraly identical to `ConstructedExpandedTravelPlan`
    # but was made for clearer understanding of the code.
    class ConstructedOptimisedExpandedTravelPlan
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
  end
end