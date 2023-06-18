class RelTravelPlansTravelStops < Jennifer::Model::Base
  table_name = :rel_travel_plans_travel_stops

  mapping(
    id: { type: Int64, primary: true, auto_increment: true},
    travel_plan_id: { type: Int64 },
    travel_stop_id: { type: Int64 }
  )
end
