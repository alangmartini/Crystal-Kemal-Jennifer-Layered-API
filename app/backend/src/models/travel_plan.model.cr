require "jennifer"

class TravelPlan < Jennifer::Model::Base
  mapping(
    id: Primary32,
    travel_stops: Int32,
  )
end
