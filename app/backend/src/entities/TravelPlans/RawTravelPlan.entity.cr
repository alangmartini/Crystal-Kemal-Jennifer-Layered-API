module TravelPlansRoute
  module Entities
    class RawTravelPlan
      include JSON::Serializable
    
      @[JSON::Field]
      property id : Int32
    end
  end
end