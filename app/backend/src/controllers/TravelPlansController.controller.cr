require "../services/TravelPlansService.service"
require "../entities/TravelPlans/TravelStopsJSON.entity"
require "./helper/HelperTravelPlansController.helper"

class TravelPlansController
  @TravelPlansService : AbstractTravelPlanService

  # Initialize the correspondet Service to utilize
  def initialize
    @TravelPlansService = TravelPlansService.new()
  end


  # Create new TravelPlan. Used in POST /travel_plans
  #
  # Uses Content-Length header to check for Body.
  # If Content-Length is 0, then it returns a 400 Bad Request
  #
  # Instantiate and calls `TravelPlansService` methods
  #
  # @param env : HTTP::Server::Context
  def create_travel_plan(env : HTTP::Server::Context)
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

    begin
      # created_travel_plan : ConstructedTravelPlan =
      #   @TravelPlansService
      #     .create_travel_plan(travel_stops)

      created_travel_plan =
        @TravelPlansService
          .create_travel_plan(travel_stops)

      HelperTravelPlansController
        .set_response_json(
          "", 201, env
        )

      return created_travel_plan.to_json
    rescue e
      puts e
      puts e.message
      return HelperTravelPlansController
        .set_response_json("error", 400, env)
    end
  end

  
end