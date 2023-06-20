class TravelPlanOptimiser
  # The TravelPlanConstructor class has one responsibility: to construct travel plans.
  def self.construct_travel_plans(
      is_expand : Bool,
      constructed_response : Array(ConstructedTravelPlan),
      optimised_simplified_locations : Array(SimplifiedLocation)
    ) : Array(ConstructedTravelPlan | ConstructedExpandedTravelPlan)

    # If expand, create `ConstructedExpandedTravelPlan` objects
    # else create `ConstructedTravelPlan` objects.
    constructed_response.map do |response|
      if is_expand
        expanded_travel_stops = TravelStopsCreator
          .create_expanded_travel_stops(
            response.travel_stops,
            optimised_simplified_locations
          )

        ConstructedExpandedTravelPlan.new(
          id = response.id,
          travel_stops = expanded_travel_stops
        )
      else
        not_expanded_travel_stops = TravelStopsCreator
          .create_not_expanded_travel_stops(
            response.travel_stops,
            optimised_simplified_locations
          )

          ConstructedTravelPlan.new(
          id = response.id,
          travel_stops = not_expanded_travel_stops
        )
      end
    end
  end
end
