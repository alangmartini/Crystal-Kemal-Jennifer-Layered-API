# /routes/user_routes.cr
require "kemal"
require "http/client"
require "json"
require "jennifer"

require "/controllers/TravelPlansController.controller"
travel_plans_controller = TravelPlansController::Controller.new()

module TravelPlansRoute
  alias ConstructedExpandedTravelPlan = TravelPlansRoute::Entities::ConstructedExpandedTravelPlan
  alias ConstructedOptimisedExpandedTravelPlan = TravelPlansRoute::Entities::ConstructedOptimisedExpandedTravelPlan
  alias ConstructedOptimisedTravelPlan = TravelPlansRoute::Entities::ConstructedOptimisedTravelPlan
  alias ConstructedTravelPlan = TravelPlansRoute::Entities::ConstructedTravelPlan
  alias ExpandedTravelStop = TravelPlansRoute::Entities::ExpandedTravelStop
  alias RawTravelPlan = TravelPlansRoute::Entities::RawTravelPlan
  alias TravelStopsJSON = TravelPlansRoute::Entities::TravelStopsJSON
  
  post "/travel_plans" do |env|
    travel_plans_controller.create_travel_plan(env)
  end

  put "/travel_plans/:id" do |env|
    travel_plans_controller.update_travel_plan(env)
  end

  delete "/travel_plans/:id" do |env|
    travel_plans_controller.delete_travel_plan(env)
  end

  get "/travel_plans" do |env|
    travel_plans_controller.get_all_travel_plans(env)
  end

  get "/travel_plans/:id" do |env|
    travel_plans_controller.get_by_id_travel_plan(env)
  end
end
