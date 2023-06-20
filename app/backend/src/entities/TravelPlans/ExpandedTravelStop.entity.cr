# A ExpandedTravelStop is deeply related to a `Location`
# The latter, though, is a JSON Serializer and has
# a aditional property Residents, used solely
# for optimising the travel stops.
class ExpandedTravelStop
  property id : Int64
  property dimension : String
  property name : String

  getter :type
  setter :type


  def initialize(@id : Int64, @dimension : String, @name : String, @type : String)
  end

  def type
    @type
  end

  def type=(value)
    @type = value
  end

  def to_json(json : JSON::Builder)
    json.object do
      json.field("id", @id)
      json.field("dimension", @dimension)
      json.field("name", @name)
      json.field("type", @type)
    end
  end
end