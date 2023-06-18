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

  get "/travel-plans" do |env|
    result = TravelPlans.all.to_json
    
    travel_stops = [] of NamedTuple(id: Int32, travel_stops: Array(Int32))

    JSON.parse(result).as_a.each do |row|
      id = row["id"].as_i
      travel_stops_id =  RelTravelPlansTravelStops
        .all
        .where { _travel_plan_id == id }
        .to_json(only: %w[travel_stop_id])

      teste = JSON.parse(travel_stops_id).as_a.map { |row| row["travel_stop_id"].as_i }
      
      puts typeof(teste.inspect)

      travel = { "id": id, "travel_stops": teste, }
      puts "travel #{travel}"
      travel_stops << travel
    end

    env.response.content_type = "application/json"
    env.response.status_code = 200

    travel_stops.to_json
  end
end
