require "src/abstracts/controllers/absTravelPlansController.abstract"

require "src/controllers/helper/BodyParser.helper"
require "src/controllers/helper/ManageResponse.helper"

require "src/services/TravelPlansService.service"

require "src/errors/NotFound.error"

require "src/entities/TravelPlans/TravelStopsJSON.entity"
require "src/entities/TravelPlans/RawTravelPlan.entity"
require "src/entities/TravelPlans/ConstructedTravelPlan.entity"
require "src/entities/TravelPlans/ConstructedOptimisedTravelPlan.entity"
require "src/entities/TravelPlans/ConstructedExpandedTravelPlan.entity"
require "src/entities/TravelPlans/ConstructedOptimisedExpandedTravelPlan.entity"

# Controller for TravelPlans routes
#
# Instantiate and calls `TravelPlansService` methods
module TravelPlansRoute
  module TravelPlansController
    class Controller < AbstractTravelPlansController
      @TravelPlansService : TravelPlansService::AbstractTravelPlansService

      # Initialize the correspondet Service to utilize
      def initialize
        @TravelPlansService = TravelPlansService::Service.new()
      end

      # Create new TravelPlan. Used in POST /travel_plans
      #
      def create_travel_plan(env : HTTP::Server::Context)
        begin
          if env.request.body.nil?
            return Helper
              .set_response_json(
                "Travel Stops are required", 400, env
              )
          end

          travel_stops_body : IO =
            env.request.body.not_nil!

          travel_stops : Entities::TravelStopsJSON =
              Helper::BodyParser
                .read_travel_stops_from_body_with_unserializer(
                  travel_stops_body
                )

          created_travel_plan =
            @TravelPlansService
              .create_travel_plan(travel_stops)

          Helper
            .set_response_json(
              "", 201, env
            )

          return created_travel_plan.to_json
        rescue e : ArgumentError
          return Helper
            .set_response_json(
              e.message.not_nil!, 400, env
            )
        rescue e
          return Helper
            .set_response_json(e.message.to_json, 500, env)
        end
      end

      # Update a TravelPlan. Used in PUT /travel_plans/:id
      #
      def update_travel_plan(env : HTTP::Server::Context)
        begin
          id : String | Nil = env.params.url["id"]

          if id.nil?
            return Helper.set_response_json(
                "No ID provided", 400, env
              )        
          end

          travel_stops_json : TravelStopsJSON | Nil = Helper::BodyParser
            .get_travel_stops_from_body(env)

          if travel_stops_json.nil?
            return Helper.set_response_json(
                "Travel Stops are required", 400, env
              )
          end

          updated_travel_plan = @TravelPlansService
            .update_travel_plan(id.to_i, travel_stops_json.not_nil!)

          Helper
            .set_response_json(
              "", 200, env
            )

          return updated_travel_plan.to_json
        rescue e : ArgumentError
          return Helper
            .set_response_json(
              e.message.not_nil!, 400, env
            )
        rescue e : Errors::NotFound
          return Helper
            .set_response_json(
              e.message.not_nil!, 404, env
            )
        rescue e
          return Helper
            .set_response_json(e.message.to_json, 500, env)
        end
      end

      # Delete a TravelPlans. Used in DELETE /travel_plans
      #
      def delete_travel_plan(env : HTTP::Server::Context)
        begin
          id : String | Nil = env.params.url["id"]

          if id.nil?
            return Helper.set_response_json(
                "No ID provided", 400, env
              )        
          end

          # Raises error if anything goes wrong
          @TravelPlansService.delete_travel_plan(id.to_i)

          Helper
            .set_response_json(
              "", 204, env
            )

          return
        rescue e : ArgumentError
          return Helper
            .set_response_json(
              e.message.not_nil!, 400, env
            )
        rescue e : Errors::NotFound
          return Helper
            .set_response_json(
              e.message.not_nil!, 404, env
            )
        rescue e
          return Helper
            .set_response_json(e.message.to_json, 500, env)
        end
      end

      # Get all TravelPlans. Used in GET /travel_plans
      #
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

          Helper
            .set_response_json("", 200, env)

          return all_travel_plans.to_json
        
        rescue e : ArgumentError
          return Helper
            .set_response_json(
              e.message.not_nil!, 400, env
            )
        rescue e
          return Helper
            .set_response_json(e.message.to_json, 500, env)
        end
      end

      def get_by_id_travel_plan(env : HTTP::Server::Context)
        begin
          id : String | Nil = env.params.url["id"]

          if id.nil?
            return Helper.set_response_json(
                "No ID provided", 400, env
              )        
          end

          # Cast String as Bool
          optimise = env.params.query["optimize"]? == "true"
          expand = env.params.query["expand"]? == "true"

          travel_plan :
            ConstructedTravelPlan |
            ConstructedExpandedTravelPlan |
            ConstructedOptimisedTravelPlan |
            ConstructedOptimisedExpandedTravelPlan = @TravelPlansService
                .get_by_id_travel_plan(id.to_i, optimise, expand)

          Helper
            .set_response_json("", 200, env)

          return travel_plan.to_json
        
        rescue e : ArgumentError
          return Helper
            .set_response_json(
              e.message.not_nil!, 400, env
            )
        rescue e : Errors::NotFound
          puts "message is #{e.message}"
          return Helper
            .set_response_json(
              "ID not Found", 404, env
            )
        rescue e
          return Helper
            .set_response_json(e.message.to_json, 500, env)
        end
      end
    end
  end
end