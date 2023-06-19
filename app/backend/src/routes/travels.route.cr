# /routes/user_routes.cr
require "kemal"
require "http/client"
require "json"
require "jennifer"
require "../models/travel_plan.model"
require "../models/rel_travel_plans_travel_stops.model"

require "../entities/TravelPlans/**"
require "../entities/RickAndMorty/**"

module UserRoutes
  post "/travel_plans" do |env|

    body = env.request.body.try &.gets_to_end

    if body
      parsed_body = JSON.parse(body)
      travel_stops = parsed_body["travel_stops"].as_a
    else
      travel_stops = { "travel_stops": [] of Int32 }
    end
    
    
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
    optimize = env.params.query["optimize"]?
    expand = env.params.query["expand"]?

    constructed_travel_plans : Array(ConstructedTravelPlan)  = GetTravelPlansResponseConstructor
      .get_all_constructed_travel_plans()

    puts constructed_travel_plans

    # if optimize || expand
    #   rick_and_morty_api_response = HTTP::Client
    #     .get("https://rickandmortyapi.com/api/location/#{travel_stops.join(",")}")

    #   locations_arr = JSON.parse(rick_and_morty_api_response.body).as_a
      
    #   # if optimize
    #   #   constructed_response = constructed_response.map do |travel|
    #   #     new_travel_stops = travel["travel_stops"].map do |travel_stop|
    #   #       location = locations_arr.find { |location| location["id"] == travel_stop }
            
    #   #     end
    #   #     { "id": travel["id"], "travel_stops": new_travel_stops }
    #   #   end
    #   # end
      
    #   # if expand
    #   #   constructed_response = constructed_response.map do |travel|
    #   #     new_travel_stops = travel["travel_stops"].map do |travel_stop|
    #   #       location = locations_arr.find { |location| location["id"] == travel_stop }
    #   #       if location
    #   #         {
    #   #           "id": location["id"],
    #   #           "name": location["name"],
    #   #           "type": location["type"],
    #   #           "dimension": location["dimension"],
    #   #         }
    #   #       else
    #   #         travel_stop
    #   #       end
    #   #     end
    #   #     { "id": travel["id"], "travel_stops": new_travel_stops }
    #   #   end

    #   # end
    # end

    # env.response.content_type = "application/json"
    # env.response.status_code = 200

    # constructed_response.to_json
  end
end
