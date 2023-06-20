class RelTravelPlansTravelStops < Jennifer::Model::Base
  table_name = :rel_travel_plans_travel_stops

  mapping(
    id: { type: Int32, primary: true, auto_increment: true},
    travel_plan_id: { type: Int32 },
    travel_stop_id: { type: Int32 }
  )

  belongs_to :travel_plan, TravelPlans
end
