class TravelPlanLocation
  property id : String
  property dimension : String
  property name : String
  property "type" : String

  def initialize(@id : String, @dimension : String, @name : String, @type : String)
  end
end