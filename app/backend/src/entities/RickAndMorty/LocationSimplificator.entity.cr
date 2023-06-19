class LocationSimplificator
  def self.calculate_residents(residents_arr : Array(Resident)) : Int32
    episode_size = [] of Int32
    residents_arr.each do |resident|
      resident.episode.each do |character|
        episode_size << character.characters.size
      end
    end

    episode_size.sum
  end

  def self.simplify(
    arr_of_locations : Array(Location)
  )
    # Copy to new_locations the content in locations
    # while emptying the memory at the same time.
    # This allows to do a map without holding two copies
    # of the very big variable locations
    new_locations = [] of SimplifiedLocation

    arr_of_locations.each do |location|
      
      new_resident = self.calculate_residents(location.residents)

      new_location = SimplifiedLocation.new(
        id: location.id,
        dimension: location.dimension,
        name: location.name,
        residents: new_resident
      )

      new_locations << new_location

      location = nil
    end

    new_locations
  end
end
