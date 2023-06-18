require "jennifer"

class TravelPlans < Jennifer::Model::Base
  table_name :travel_plans

  mapping(
    id: { type: Int64, primary: true, auto_increment: true},
  )
end
