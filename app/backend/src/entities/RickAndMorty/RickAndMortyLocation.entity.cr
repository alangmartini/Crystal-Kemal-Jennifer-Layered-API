require "json"

class Character
  include JSON::Serializable

  @[JSON::Field]
  property id : String
end

class Episode
  include JSON::Serializable

  @[JSON::Field]
  property characters : Array(Character)
end

class Resident
  include JSON::Serializable

  @[JSON::Field]
  property episode : Array(Episode)
end

class Location
  include JSON::Serializable

  @[JSON::Field]
  property id : String

  @[JSON::Field]
  property dimension : String

  @[JSON::Field]
  property name : String

  @[JSON::Field]
  property residents : Array(Resident)
end