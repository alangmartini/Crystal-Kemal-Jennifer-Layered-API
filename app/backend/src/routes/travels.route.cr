# /routes/user_routes.cr
require "kemal"
require "../models/travel_plan.model"
require "jennifer"

module UserRoutes
  get "/" do |env|

    # travel_plan = TravelPlan.create({
    #   name: "My Travel Plan",
    #   travel_stops: [
    #     TravelStop.create({
    #       name: "Stop 1",
    #       location: "Location 1"
    #     }),
    #     TravelStop.create({
    #       name: "Stop 2",
    #       location: "Location 2"
    #     })
    #   ]
    # })

    travel_plan = TravelPlans.create({ travel_stops: 1 })
    
    puts travel_plan
    {
      "id": 1,
      "travel_stops": [1, 2]
    }.to_json
  end
end
