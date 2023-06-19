class LocationOptimiser
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
