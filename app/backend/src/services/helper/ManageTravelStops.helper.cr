require "entities/ExpandedTravelStop"

module TravelPlansService
  # Module for handling Travel Stops operations, like expading
  # creation or transformations.
  module ManageTravelStops
    alias SimplifiedLocation = RickAndMorty::Entities::SimplifiedLocation

    # Uses the information from `Location`
    # to expand a TravelStop into a `ExpandedTravelStop`.
    #
    # A expanded travel stop its just a travel_stop (Int32)
    # with details about the location.
    def self.expand_travel_stops(
      optimised_simplified_locations : Array(SimplifiedLocation),
      travel_stops : Array(Int32)
    ) : Array(ExpandedTravelStop)
      new_travel_stops  = optimised_simplified_locations
      .select { |location| travel_stops
        .includes?(location.id) }
      
      new_travel_stops = new_travel_stops.map do |travel_stops|
        ExpandedTravelStop.new(
          id: travel_stops.id,
          name: travel_stops.name,
          dimension: travel_stops.dimension,
          type: travel_stops._type
        )
      end

      new_travel_stops
    end

    # Returns the ExpandedTravelStop to normal TravelStops, which
    # only contain the id.
    def self.unexpand_travel_stops(
      expanded_travel_stops : Array(ExpandedTravelStop)
    ) : Array(Int32)
      expanded_travel_stops.map { |travel_stop| travel_stop.id }
    end
  end
end