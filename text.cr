# /routes/user_routes.cr
require "kemal"
require "http/client"
require "json"
require "jennifer"

require "../models/TravelPlans.model"
require "../models/RelTravelPlansTravelStops.model"

require "../entities/**"
require "../actions/**"
require "../controllers/**"


travel_plans_controller = TravelPlansController.new()

module TravelPlansRoute
  post "/travel_plans" do |env|
    body = env.request.body.try &.gets_to_end

    if body
      parsed_body = JSON.parse(body)
      travel_stops = parsed_body["travel_stops"].as_a
    else
      env.response.content_type = "application/json"
      env.response.status_code = 400

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