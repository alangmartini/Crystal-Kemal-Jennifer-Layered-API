require "src/RickAndMorty/entities/Location.entity"
require "src/RickAndMorty/entities/SimplifiedLocation.entity"
require "src/RickAndMorty/ApiClient"
require "src/services/helper/ManageLocation.helper.cr"

module TravelPlansRoute
  module TravelPlansService
    # Helper module for `TravelPlansService` module.
    module Helper
      # Module that contains the logic to get the `Location` entity
      # from RickAndMorty Api.
      #
      # Uses `LocationSimplificator` and `LocationOptimiser` to
      # simplify  the `Location` entity and, if necessary, optimise.
      module GetAndConstructLocations
        alias Location = RickAndMorty::Entities::Location
        alias SimplifiedLocation = RickAndMorty::Entities::SimplifiedLocation
        
        # Get locations from RickAndMorty API and construct to
        # `SimpleLocation` entity. Raises error if Api is not available.
        def self.get_locations(
            optimise : Bool,
            travel_stops : Array(Int32),
            constructed_travel_plans : Array(ConstructedTravelPlan)
          ) : Array(SimplifiedLocation)
          # TODO: apply threading
          # Fetch all locations by travel stops
          graph_ql_query = RickAndMorty::ApiClient.new(travel_stops)
          response : JSON::Any = graph_ql_query.execute()

          if response.nil?
            raise ArgumentError.new("RickAndMorty API is not available")
          end

          # Transform json answer to more easily managable object.
          locations : Array(Location) = response["data"]["locationsByIds"]
          .as_a.map { |location| Location.from_json(location.to_json) }

          # `SimplifiedLocations` only hold the amount of residents
          # in the correspondet key. They are, thus, much much lighter.
          #
          # This was necessary because Rick and Morty GraphQL API doesnt have
          # a totalCount key for residents.
          simplified_locations : Array(SimplifiedLocation) =
            ManageLocation::LocationSimplificator
              .simplify(locations)

          # Check ManageLocation::LocationOptimiser for rules followed 
          # on optimising.
          
          if optimise
            puts "hello"
            optimised_location : Array(SimplifiedLocation) = 
              ManageLocation::LocationOptimiser
                .optimise(simplified_locations)

            simplified_locations = optimised_location
          end

          simplified_locations
        end
      end
    end
  end
end