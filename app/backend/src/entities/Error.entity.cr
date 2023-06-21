class Error
include JSON::Serializable

  @[JSON::Field]
  property message : String

  @[JSON::Field]
  property status_code : Int32
end


