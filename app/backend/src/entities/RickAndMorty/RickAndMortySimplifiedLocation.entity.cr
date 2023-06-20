require "json"

class SimplifiedLocation
  property id : String
  property dimension : String
  property name : String
  property "type" : String
  property residents : Int32

  def initialize(
    @id : String,
    @dimension : String,
    @name : String,
    @type : String,
    @residents : Int32
  )
  end
end
