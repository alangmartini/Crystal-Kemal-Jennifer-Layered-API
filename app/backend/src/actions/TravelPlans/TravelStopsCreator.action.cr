class TravelStopsCreator
  def self.create_optimised_expanded_new_travel_stops(
      optimised_simplified_locations : Array(SimplifiedLocation),
      travel_stops : Array(Int64)
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

  def self.unexpand_travel_stops(
    expanded_travel_stop : Array(ExpandedTravelStop)
  ) : Array(Int64)
    expanded_travel_stop
      .map { |location| location.id.to_i64 }
  end

  def self.create_expanded_travel_stops(
    travel_stops : Array(Int64),
    optimised_simplified_locations : Array(SimplifiedLocation)
  ) : Array(ExpandedTravelStop)
    optimised_extended_travel_stops =
      self.create_optimised_expanded_new_travel_stops(
        optimised_simplified_locations,
        travel_stops
      )

    optimised_extended_travel_stops
  end

  def self.create_not_expanded_travel_stops(
    travel_stops : Array(Int64),
    optimised_simplified_locations : Array(SimplifiedLocation)
  ) : Array(Int64)
    optimised_extended_travel_stops =
      self.create_optimised_expanded_new_travel_stops(
        optimised_simplified_locations,
        travel_stops
      )

    self.unexpand_travel_stops(optimised_extended_travel_stops)
  end


end
