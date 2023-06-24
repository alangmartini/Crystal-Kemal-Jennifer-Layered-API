# /routes/user_routes.cr
require "kemal"
require "http/client"
require "json"
require "jennifer"

require "/controllers/TravelPlansController.controller"
travel_plans_controller = TravelPlansController.new()

module TravelPlansRoute
  post "/travel_plans" do |env|
    travel_plans_controller.create_travel_plan(env)
  end

  put "/travel_plans/:id" do |env|
    puts "oi"
  #   id = env.params.url["id"]

  #   if !id
  #     env.response.content_type = "application/json"
  #     env.response.status_code = 404

  #     next {
  #       message: "No ID provided",
  #       status_code: 400
  #     }
  #   end

  #   body = env.request.body.try &.gets_to_end

  #   if body
  #     parsed_body = JSON.parse(body)
  #     travel_stops = parsed_body["travel_stops"].as_a
  #   else
  #     env.response.content_type = "application/json"
  #     env.response.status_code = 400

  #     next {
  #       message: "No body provided",
  #       status_code: 400
  #     }
  #   end

  #   travel_plan = GetTravelPlansResponseConstructor
  #     .get_raw_travel_plan_from_db_by_id(id).first

  #   if !travel_plan
  #     env.response.content_type = "application/json"
  #     env.response.status_code = 404

  #     next {
  #       message: "No TravelPlan with ID #{id} found",
  #       status_code: 404
  #     }
  #   end

  #   travel_stops_travel_plan = GetTravelPlansResponseConstructor
  #     .get_travel_stops_from_db(travel_plan)
    

  #   # Starts a transaction
  #   # TODO: Right now, if body has less travel stops than the
  #   # travel_plan, it will generate duplicate travel_stops.
  #   # To solve, its necessary to check the lenghts and delete
  #   # the excessive part from the DB.
  #   Jennifer::Adapter.default_adapter.transaction do |tx|
  #     travel_stops.each_with_index do |travel_stop, index|
  #       value = travel_stop.is_a?(Symbol) ? travel_stop.to_s.to_i32? : travel_stop.as_i?
        
      
  #       RelTravelPlansTravelStops
  #         .where { (_travel_plan_id == id) & (_travel_stop_id == travel_stops_travel_plan[index]) }
  #         .update(travel_stop_id: value)

        
  #     end
  #   end
    
  #   env.response.content_type = "application/json"
  #   env.response.status_code = 200

  #   {
  #   "id": id.to_i,
  #   "travel_stops": travel_stops
  #   }.to_json
  # end

  # delete "/travel_plans/:id" do |env|
  #   id = env.params.url["id"]

  #   if !id
  #     env.response.content_type = "application/json"
  #     env.response.status_code = 404

  #     next {
  #       message: "No ID provided",
  #       status_code: 400
  #     }
  #   end

  #   travel_plan = GetTravelPlansResponseConstructor
  #     .get_raw_travel_plan_from_db_by_id(id).first

  #   if !travel_plan
  #     env.response.content_type = "application/json"
  #     env.response.status_code = 404

  #     next {
  #       message: "No TravelPlan with ID #{id} found",
  #       status_code: 404
  #     }
  #   end

  #   travel_stops_travel_plan = GetTravelPlansResponseConstructor
  #     .get_travel_stops_from_db(travel_plan)

  #   # Starts a transaction
  #   Jennifer::Adapter.default_adapter.transaction do |tx|
  #     travel_stops_travel_plan.each_with_index do |travel_stop, index|
  #       RelTravelPlansTravelStops
  #       .where { (_travel_plan_id == id) & (_travel_stop_id == travel_stops_travel_plan[index]) }
  #       .delete
  #     end

  #     TravelPlans.where {
  #       _id == id
  #     }.delete
  #   end

  #   env.response.content_type = "application/json"
  #   env.response.status_code = 204
  end

  get "/travel_plans" do |env|
    travel_plans_controller.get_all_travel_plans(env)
  end

  # get "/travel_plans/:id" do |env|
  #   begin
  #     id = env.params.url["id"]
  #     Cast String as Bool
  #     optimise = env.params.query["optimize"]? == "true"
  #     expand = env.params.query["expand"]? == "true"

  #     if !id
  #       env.response.content_type = "application/json"
  #       env.response.status_code = 404

  #       next {
  #         message: "No ID provided",
  #         status_code: 400
  #       }.to_json
  #     end

  #     constructed_travel_plan : Array(ConstructedTravelPlan) =
  #       GetTravelPlansResponseConstructor
  #         .get_by_id_constructed_travel_plans(id)
      
  #     if constructed_travel_plan.size == 0
  #       puts "new hero"
  #       env.response.content_type = "application/json"
  #       env.response.status_code = 404
  
  #       next {
  #         message: "No travel plans found for given ID",
  #         status_code: 404
  #       }.to_json
  #     end

  #     if !optimise && !expand
        
  #       env.response.content_type = "application/json"
  #       env.response.status_code = 200
    
  #       next constructed_travel_plan.first.to_json
  #     end

  #     travel_stops =
  #     GetTravelPlansResponseConstructor
  #       .get_all_unique_travel_stops_ids(
  #         constructed_travel_plan
  #       )

  #     graph_ql_query = RickAndMortyApiClient.new(travel_stops)
  #     response : JSON::Any = graph_ql_query.execute()

  #     locations : Array(Location) = response["data"]["locationsByIds"]
  #       .as_a.map { |location| Location.from_json(location.to_json) }

  #     simplified_location : Array(SimplifiedLocation) = LocationSimplificator
  #       .simplify(locations)
      
  #     if optimise
  #       optimised_location :
  #         Array(SimplifiedLocation) =
  #           LocationOptimiser
  #             .optimise(simplified_location)

  #       simplified_location = optimised_location
  #     end


  #     expand_and_or_optimised_constructed_travel_plan :
  #       Array(
  #         ConstructedTravelPlan |
  #         ConstructedExpandedTravelPlan
  #       ) =
  #           TravelPlanOptimiser.construct_travel_plans(
  #             expand,
  #             constructed_travel_plan,
  #             simplified_location
  #           )

  #     env.response.content_type = "application/json"
  #     env.response.status_code = 200
      
  #     next expand_and_or_optimised_constructed_travel_plan
  #       .first
  #       .to_json

  #   rescue e
  #     puts "what"
  #     env.response.content_type = "application/json"
  #     env.response.status_code = 500

  #     next {
  #       "message" => "Something went wrong #{e}",
  #       "status_code" => 500
  #     }.to_json
  #   end
  # end
end
