# /routes/user_routes.cr
require "kemal"
require "../models/travel_plan.model"
require "../models/rel_travel_plans_travel_stops.model"
require "jennifer"

module UserRoutes
  post "/travel-plans" do |env|

    body = env.request.body.try &.gets_to_end

    if body
      parsed_body = JSON.parse(body)
      travel_stops = parsed_body["travel_stops"].as_a
    else
      travel_stops = { "travel_stops": [] of Int64 }
    end
    
    
    travel_plan = TravelPlans.create({} of String => Int64)

    travel_id = travel_plan.id

    if travel_id
      travel_stops.each do |travel_stop|
        value = travel_stop.is_a?(Symbol) ? travel_stop.to_s.to_i64? : travel_stop.as_i64?

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
end
