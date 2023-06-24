require "src/abstracts/services/absTravelPlansService.abstract"

require "src/RickAndMorty/ApiClient"
require "src/RickAndMorty/entities/SimplifiedLocation.entity"

require "src/services/helper/ManageLocation.helper"
require "src/services/helper/GetAndConstructLocations.helper"
require "src/services/helper/GetAndConstructTravelPlans.helper"
require "src/services/helper/ManageTravelPlan.helper"

require "src/entities/TravelPlans/RawTravelPlan.entity"
require "src/entities/TravelPlans/ConstructedTravelPlan.entity"
require "src/entities/TravelPlans/ConstructedOptimisedTravelPlan.entity"
require "src/entities/TravelPlans/ConstructedExpandedTravelPlan.entity"
require "src/entities/TravelPlans/ConstructedOptimisedExpandedTravelPlan.entity"


module TravelPlansRoute
  module TravelPlansService
      class Service < AbstractTravelPlansService
        alias SimplifiedLocation = RickAndMorty::Entities::SimplifiedLocation
        alias Location = RickAndMorty::Entities::Location


        @TravelPlanModel : TravelPlans.class
        @TravelStopsModel : RelTravelPlansTravelStops.class

        def initialize()
          @TravelPlanModel = TravelPlans
          @TravelStopsModel = RelTravelPlansTravelStops
        end

        def create_travel_plan(travel_stops_json : TravelStopsJSON)
          # TravelPlans only holds the travel plan id, with auto_increment
          created_travel_plans =
              @TravelPlanModel.create()
          
          if created_travel_plans.nil?
            raise ArgumentError
              .new("TravelStopsJSON is not valid") 
          end

          raw_travel_plan = RawTravelPlan
            .from_json(created_travel_plans.to_json)

          # With the id in hands, we can now create the travel stops
          travel_stops = Helper::ManageTravelStops.create_travel_stops(
            travel_stops_json,
            raw_travel_plan.id
          )

          constructed_travel_plan = ConstructedTravelPlan.new(
            id: raw_travel_plan.id,
            travel_stops: travel_stops
          )

          constructed_travel_plan
        end

        def update_travel_plan(
          id : Int32,
          travel_stops_json : TravelStopsJSON,
        )
          # We wont need a `ConstructedTravelPlan` since we only
          # need the id to update.
          raw_travel_plan = Helper::GetAndConstructTravelPlans
            .get_raw_travel_plan_from_db_by_id(id)

          if raw_travel_plan.nil?
            raise ArgumentError.new("No Travel Plan with given ID")
          end

          # Starts a transaction
          # I decided to remove and created, even if the PK wont reset
          # since it handles the case where the to update travel_stops
          # don't have the same length as the current travel_stops

          travel_stops : Array(Int32) = travel_stops_json.travel_stops
          # TODO: take this out of service and create an appropriate class
          # or module for transactions and other db methods.
          Jennifer::Adapter.default_adapter.transaction do |tx|
            travel_stops.each_with_index do |travel_stop, index|
              @TravelStopsModel
                .where { (_travel_plan_id == id) }
                .delete()
            
              @TravelStopsModel
                .create({
                  travel_plan_id: id,
                  travel_stop_id: travel_stop
                })
            end
          end

          return {
            id: id,
            travel_stops: travel_stops
          }
        end

        # Get all TravelPlans in DB, optimising or expanding them
        # into `ConstructedTravelPlan` or `ConstructedExpandedTravelPlan`
        def get_all_travel_plans(
          expand : Bool,
          optimise : Bool
        ) : Array(ConstructedTravelPlan) |
          Array(ConstructedExpandedTravelPlan) |
          Array(ConstructedOptimisedTravelPlan) |
          Array(ConstructedOptimisedExpandedTravelPlan)

          constructed_travel_plans = 
            Helper::GetAndConstructTravelPlans
              .get_all_constructed_travel_plans()

          if constructed_travel_plans.empty? || (!optimise && !expand)
            return constructed_travel_plans
          end

          # Starting work in expanding and optimising the travel plans.
          # Gets the Locations (which are the Travel Stops expanded, or with
          # more information, if you will) from the Api. Already
          # optimises it if necessary.
          #
          # constructed_travel_plans is a parameter 
          # because it needs a reference for doing optimisation.
          travel_stops : Array(Int32) = 
            Helper::GetAndConstructTravelPlans
              .get_all_unique_travel_stops_ids(constructed_travel_plans)

          simplified_locations : Array(SimplifiedLocation) = 
            Helper::GetAndConstructLocations
              .get_locations(optimise, travel_stops, constructed_travel_plans)

          if !expand
            reconstructed_optimised_travel_plans :
              Array(ConstructedOptimisedTravelPlan) =
                Helper::ManageTravelPlan
                  .reconstruct_optimised_travel_plans(
                    constructed_travel_plans,
                    simplified_locations
                  )

            return reconstructed_optimised_travel_plans
          end

          if !optimise
            reconstructed_expanded_travel_plans :
              Array(ConstructedExpandedTravelPlan) =
                Helper::ManageTravelPlan
                  .reconstruct_expanded_travel_plans(
                    constructed_travel_plans,
                    simplified_locations
                  )

            return reconstructed_expanded_travel_plans
          end

          reconstructed_expanded_and_optimised_travel_plans :
            Array(ConstructedOptimisedExpandedTravelPlan) =
              Helper::ManageTravelPlan
                .reconstruct_expanded_and_optimised_travel_plans(
                  constructed_travel_plans,
                  simplified_locations
                )

          return reconstructed_expanded_and_optimised_travel_plans
        end
      end
  end
end