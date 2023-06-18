require "jennifer"

class TravelPlans < Jennifer::Model::Base
  table_name :travel_plans

  mapping(
    id: { type: Int32, primary: true, auto_increment: true},
  )

  has_many :rel_travel_plans_travel_stops, RelTravelPlansTravelStops
end
