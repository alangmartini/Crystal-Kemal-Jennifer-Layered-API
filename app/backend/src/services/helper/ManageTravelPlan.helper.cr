require "src/services/helper/ManageTravelStops.helper"
require "src/entities/TravelPlans/ConstructedTravelPlan.entity"
require "src/entities/TravelPlans/ConstructedOptimisedTravelPlan.entity"
require "src/entities/TravelPlans/ConstructedExpandedTravelPlan.entity"
require "src/entities/TravelPlans/ConstructedOptimisedExpandedTravelPlan.entity"

module TravelPlansService
  # Module for operations involving the reconstruction
  # of `ConstructedTravelPlan` into its optimised
  # and/or expanded version.
  module ManageTravelPlan
    alias SimplifiedLocation = RickAndMorty::Entities::SimplifiedLocation
    # Reconstruction of `ConstructedTravelPlan` into its
    # optimised version: `ConstructedOptimisedTravelPlan`.
    def self.reconstruct_optimised_travel_plans(
      constructed_travel_plans : Array(ConstructedTravelPlan),
      simplified_locations : Array(SimplifiedLocation)
    ) : Array(ConstructedOptimisedTravelPlan)
      constructed_travel_plans.map do |constructed_travel_plan|
        travel_stops : Array(Int32) = ManageTravelStops
          .get_unexpanded_travel_stops(
            simplified_locations,
            constructed_travel_plan.travel_stops
          )

        ConstructedOptimisedTravelPlan.new(
          constructed_travel_plan.id,
          travel_stops,
        )
      end
    end
    # Reconstruction of `ConstructedTravelPlan` into its
    # expanded version: `ConstructedExpandedTravelPlan`.
    def self.reconstruct_expanded_travel_plans(
      constructed_travel_plans : Array(ConstructedTravelPlan),
      simplified_locations : Array(SimplifiedLocation)
    ) : Array(ConstructedExpandedTravelPlan)
      constructed_travel_plans.map do |constructed_travel_plan|
        expanded_travel_stops : Array(ExpandedTravelStop) =
            ManageTravelStops
              .get_expanded_travel_stops(
                simplified_locations,
                constructed_travel_plan.travel_stops
              )

        ConstructedExpandedTravelPlan.new(
          constructed_travel_plan.id,
          expanded_travel_stops,
        )
      end
    end

    # Reconstruction of `ConstructedTravelPlan` into its
    # expanded and optimised version:
    # `ConstructedOptimisedExpandedTravelPlan`.
    def self.reconstruct_expanded_and_optimised_travel_plans(
      constructed_travel_plans : Array(ConstructedTravelPlan),
      simplified_locations : Array(SimplifiedLocation)
      ) : Array(ConstructedOptimisedExpandedTravelPlan)
      constructed_travel_plans.map do |constructed_travel_plan|
        expanded_travel_stops : Array(ExpandedTravelStop) = ManageTravelStops
          .get_expanded_travel_stops(
            simplified_locations,
            constructed_travel_plan.travel_stops
          )

          ConstructedOptimisedExpandedTravelPlan.new(
          constructed_travel_plan.id,
          expanded_travel_stops,
        )
      end
    end
  end
end
