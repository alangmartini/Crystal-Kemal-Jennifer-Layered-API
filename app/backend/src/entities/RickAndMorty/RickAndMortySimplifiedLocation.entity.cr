# Similar to `Location`, but here the Residents file
# is flattened to a Int32 representing the amount of residents.
# which is the only information relevant to this class.
class SimplifiedLocation
  property id : Int64
  property dimension : String
  property name : String
  property residents : Int64

  # Best pratices says that we should not use `type` as a property name
  # but the challenge requires it.
  getter :_type
  setter :_type

  def initialize(
    @id : Int64,
    @dimension : String,
    @name : String,
    @_type : String,
    @residents : Int64
  )
  end

  def type
    @_type
  end

  def type=(value)
    @_type = value
  end
end
