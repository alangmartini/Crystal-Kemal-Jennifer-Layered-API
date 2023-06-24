require "src/RickAndMorty/entities/Location.entity"
require "src/RickAndMorty/entities/SimplifiedLocation.entity"


module TravelPlansService
  # Module that contains the logic to manage the `Location` entity
  module ManageLocation
    # Class that contains the logic to transform a `Location` in a
    # `SimplifiedLocation`. A `SimplifiedLocation` it's a Location
    # where the residents holds the amount of residents only.
    class LocationSimplificator
      alias Resident = RickAndMorty::Entities::Resident
      alias Location = RickAndMorty::Entities::Location
      alias SimplifiedLocation = RickAndMorty::Entities::SimplifiedLocation

      # Calculate the amount of `Resident`s in a `Location`
      def self.calculate_residents(residents_arr : Array(Resident)) : Int32
        episode_size = [] of Int32
        residents_arr.each do |resident|
          resident.episode.each do |character|
            episode_size << character.characters.size
          end
        end
    
        episode_size.sum
      end
    
      # Do the simplification of the `Location` entity to a
      # `SimplifiedLocation` entity
      def self.simplify(arr_of_locations : Array(Location))
        # Copy to new_locations the content in locations
        # while emptying the memory at the same time.
        # This allows to do a map without holding two copies
        # of the very big variable locations
        new_locations = [] of SimplifiedLocation
    
        arr_of_locations.each do |location|
          
          new_resident = self.calculate_residents(location.residents)
    
          new_location = SimplifiedLocation.new(
            id: location.id.to_i,
            dimension: location.dimension,
            name: location.name,
            residents: new_resident,
            _type: location.type_alias
          )
    
          new_locations << new_location
    
          location = nil
        end
    
        new_locations
      end
    end    

    # Optimise location according to the following rules:
    # 1. Every stop from a same dimension must be grouped
    # 2. Inside a same dimension, the stops must be ordered in ASC order of popularity
    # 3. If the popularity is the same, then order by name
    # 4. The order of visit of the dimensions is defined by the average of their total populations.
    class LocationOptimiser
      alias SimplifiedLocation = RickAndMorty::Entities::SimplifiedLocation
      
      def self.optimise(simplified_locations : Array(SimplifiedLocation)) : Array(SimplifiedLocation)
        grouped_locations = simplified_locations.group_by { |location| location.dimension }
    
        grouped_locations.each do |key, value|
          grouped_locations[key] = value.sort do |a, b|
            result = a.residents <=> b.residents
            result.zero? ? a.name <=> b.name : result
          end
        end
    
        sorted = grouped_locations.to_a.sort do |a, b|
          a_residents = a[1].map { |location| location.residents }.sum
          b_residents = b[1].map { |location| location.residents }.sum
    
          a_median = a_residents / a[1].size
          b_median = b_residents / b[1].size
    
          a_median <=> b_median
        end
    
        sorted_locations_only = [] of SimplifiedLocation
    
        sorted.each do |group_location|
          group_location[1].each do |location|
            sorted_locations_only << location
          end
        end
    
        sorted_locations_only
      end
    end 
  end
end