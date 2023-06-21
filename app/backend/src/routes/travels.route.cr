# /routes/user_routes.cr
require "kemal"
require "http/client"
require "json"
require "jennifer"

require "../models/TravelPlans.model"
require "../models/RelTravelPlansTravelStops.model"

require "../entities/**"
require "../actions/**"

module TravelPlansRoute
  post "/travel_plans" do |env|

    body = env.request.body.try &.gets_to_end

    if body
      parsed_body = JSON.parse(body)
      travel_stops = parsed_body["travel_stops"].as_a
    else
      next {
        message: "No body provided",
        status_code: 400
      }
    end
    
    # TravelPlans only consists of a auto_increment ID
    travel_plan = TravelPlans.create({} of String => Int32)

    travel_id = travel_plan.id

    if travel_id
      travel_stops.each do |travel_stop|
        value = travel_stop.is_a?(Symbol) ? travel_stop.to_s.to_i32? : travel_stop.as_i?

        RelTravelPlansTravelStops.create({
          travel_plan_id: travel_id,
          travel_stop_id: value
        })    
      end

      env.response.content_type = "application/json"
      env.response.status_code = 201

      {
      "id": travel_id,
      "travel_stops": travel_stops
      }.to_json
    end 
  end

  get "/travel_plans" do |env|
    begin
      # Cast String as Bool
      optimise = env.params.query["optimize"]? == "true"
      expand = env.params.query["expand"]? == "true"

      # Get TravelPlans from DB and construct them to ConstructedTravelPlan objects
      constructed_travel_plans : Array(ConstructedTravelPlan) =
        GetTravelPlansResponseConstructor
          .get_all_constructed_travel_plans()

      if constructed_travel_plans.empty? || (!optimise && !expand)
        env.response.content_type = "application/json"
        env.response.status_code = 200
    
        next constructed_travel_plans.to_json
      end

      travel_stops =
        GetTravelPlansResponseConstructor
          .get_all_unique_travel_stops_ids(
            constructed_travel_plans
        )

      graph_ql_query = RickAndMortyApiClient.new(travel_stops)
      response : JSON::Any = graph_ql_query.execute()
      
      locations : Array(Location) = response["data"]["locationsByIds"]
        .as_a.map { |location| Location.from_json(location.to_json) }

      simplified_locations : Array(SimplifiedLocation) = LocationSimplificator
        .simplify(locations)

      if optimise
        optimised_locations :
          Array(SimplifiedLocation) =
            LocationOptimiser
              .optimise(simplified_locations)

        simplified_locations = optimised_locations
      end

      expand_and_or_optimised_constructed_travel_plans :
        Array(
          ConstructedTravelPlan |
          ConstructedExpandedTravelPlan
        ) =
            TravelPlanOptimiser.construct_travel_plans(
              expand,
              constructed_travel_plans,
              simplified_locations
            )

      env.response.content_type = "application/json"
      env.response.status_code = 200

      next expand_and_or_optimised_constructed_travel_plans.to_json
    rescue e
      env.response.content_type = "application/json"
      env.response.status_code = 500

      next {
        "message" => "Something went wrong #{e}",
        "status_code" => 500
      }.to_json
    end
  end

  get "/travel_plans/:id" do |env|
    begin
      id = env.params.url["id"]
      # Cast String as Bool
      optimise = env.params.query["optimize"]? == "true"
      expand = env.params.query["expand"]? == "true"

      if !id
        env.response.content_type = "application/json"
        env.response.status_code = 404

        next {
          message: "No ID provided",
          status_code: 400
        }
      end

      constructed_travel_plan : Array(ConstructedTravelPlan) =
        GetTravelPlansResponseConstructor
          .get_by_id_constructed_travel_plans(id)
      puts "constructed_travel_plan #{constructed_travel_plan}"
      if constructed_travel_plan.size == 0
        env.response.content_type = "application/json"
        env.response.status_code = 404
  
        next {
          "message" => "Travel plan not found",
          "status_code" => 404
        }.to_json
      end

      if !optimise && !expand
        puts "im here"
        env.response.content_type = "application/json"
        env.response.status_code = 200
    
        next constructed_travel_plan.first.to_json
      end

      travel_stops =
      GetTravelPlansResponseConstructor
        .get_all_unique_travel_stops_ids(
          constructed_travel_plan
        )

      graph_ql_query = RickAndMortyApiClient.new(travel_stops)
      response : JSON::Any = graph_ql_query.execute()

      locations : Array(Location) = response["data"]["locationsByIds"]
        .as_a.map { |location| Location.from_json(location.to_json) }

      simplified_location : Array(SimplifiedLocation) = LocationSimplificator
        .simplify(locations)
      
      if optimise
        optimised_location :
          Array(SimplifiedLocation) =
            LocationOptimiser
              .optimise(simplified_location)

        simplified_location = optimised_location
      end


      expand_and_or_optimised_constructed_travel_plan :
        Array(
          ConstructedTravelPlan |
          ConstructedExpandedTravelPlan
        ) =
            TravelPlanOptimiser.construct_travel_plans(
              expand,
              constructed_travel_plan,
              simplified_location
            )

      env.response.content_type = "application/json"
      env.response.status_code = 200
      puts "expand_and_or_optimised_constructed_travel_plan #{expand_and_or_optimised_constructed_travel_plan}"
      next expand_and_or_optimised_constructed_travel_plan
        .first
        .to_json

    rescue e
      env.response.content_type = "application/json"
      env.response.status_code = 500

      next {
        "message" => "Something went wrong #{e}",
        "status_code" => 500
      }.to_json
    end
  end
end
