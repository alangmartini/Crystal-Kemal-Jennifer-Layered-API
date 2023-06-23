module RickAndMorty
  module Entities
    # Represents a location in the Rick and Morty universe.
    # It is a expanded Travel Stop, or, in other words,
    # contains more information about each travel stop.
    #
    # It comes from the API as a `Location` and then its
    # transformed to a `ExpandedTravelStop`. Only difference
    # between then is presence of the residents field.
    class Location
      include JSON::Serializable

      @[JSON::Field]
      property id : String

      @[JSON::Field]
      property dimension : String

      @[JSON::Field]
      property name : String

      @[JSON::Field(key: "type")]
      property type_alias : String

      @[JSON::Field]
      property residents : Array(Resident)
    end

    # Represents a residents field in the Rick and Morty universe.
    class Resident
      include JSON::Serializable

      @[JSON::Field]
      property episode : Array(Episode)
    end

    # Holds the characters from a certain episode
    # in the Rick and Morty universe.
    class Episode
      include JSON::Serializable
    
      @[JSON::Field]
      property characters : Array(Character)
    end

    # Holds the characters id from a certain episode.
    class Character
      include JSON::Serializable
    
      @[JSON::Field]
      property id : String
    end
  end
end




