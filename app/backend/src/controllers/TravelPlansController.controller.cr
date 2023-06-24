require "src/services/TravelPlansService.service"
require "src/entities/TravelPlans/TravelStopsJSON.entity"
require "src/controllers/helper/HelperTravelPlansController.helper"

require "src/entities/TravelPlans/RawTravelPlan.entity"
require "src/entities/TravelPlans/ConstructedTravelPlan.entity"
require "src/entities/TravelPlans/ConstructedOptimisedTravelPlan.entity"
require "src/entities/TravelPlans/ConstructedExpandedTravelPlan.entity"
require "src/entities/TravelPlans/ConstructedOptimisedExpandedTravelPlan.entity"

# Controller for TravelPlans routes
#
# Instantiate and calls `TravelPlansService` methods
class TravelPlansController
  @TravelPlansService : TravelPlansService::AbstractTravelPlanService

  # Initialize the correspondet Service to utilize
  def initialize
    @TravelPlansService = TravelPlansService::Service.new()
  end


  # Create new TravelPlan. Used in POST /travel_plans
  #
  # Uses Content-Length header to check for Body.
  # If Content-Length is 0, then it returns a 400 Bad Request
  #
  #
  # @param env : HTTP::Server::Context
  def create_travel_plan(env : HTTP::Server::Context)
    begin
      if env.request.body.nil?
        return HelperTravelPlansController
          .set_response_json(
            "Travel Stops are required", 400, env
          )
      end

      travel_stops_body : IO =
        env.request.body.not_nil!

      travel_stops : TravelStopsJSON =
          HelperTravelPlansController::BodyParser
            .read_travel_stops_from_body_with_unserializer(
              travel_stops_body
            )

      created_travel_plan =
        @TravelPlansService
          .create_travel_plan(travel_stops)

      HelperTravelPlansController
        .set_response_json(
          "", 201, env
        )

      return created_travel_plan.to_json
    rescue e : ArgumentError
      return HelperTravelPlansController
        .set_response_json(
          e.message.not_nil!, 400, env
        )
    rescue e
      return HelperTravelPlansController
        .set_response_json(e.message.to_json, 500, env)
    end
  end

  # Get all TravelPlans. Used in GET /travel_plans
  #
  # @param env : HTTP::Server::Context
  def get_all_travel_plans(env : HTTP::Server::Context)
    begin
      # Cast String as Bool
      optimise = env.params.query["optimize"]? == "true"
      expand = env.params.query["expand"]? == "true"
      
      all_travel_plans :
        Array(ConstructedTravelPlan) |
        Array(ConstructedExpandedTravelPlan) |
        Array(ConstructedOptimisedTravelPlan) |
        Array(ConstructedOptimisedExpandedTravelPlan) = @TravelPlansService
            .get_all_travel_plans(optimise, expand)

      HelperTravelPlansController
        .set_response_json("", 200, env)

      return all_travel_plans.to_json
    
    rescue e : ArgumentError
      return HelperTravelPlansController
        .set_response_json(
          e.message.not_nil!, 400, env
        )
    rescue e
      return HelperTravelPlansController
        .set_response_json(e.message.to_json, 500, env)
    end
  end
  
end