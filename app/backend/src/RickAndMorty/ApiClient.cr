require "src/entities/HttpClient.entity"

# class QueryResponse
#   getter data: String
# end

# Contain all methods, entities and actions related to the Rick
# and Morty API.
module RickAndMorty
  class ApiClient
    def initialize(@ids : Array(Int32))
      @http_client = HttpClient.new("rickandmortyapi.com", true)
      @query = <<-GRAPHQL
      query GetLocations($ids: [ID!]!) {
        locationsByIds(ids: $ids) {
          id
          dimension
          name
          type
          residents {
            episode {
              characters {
                id
              }
            }
          }
        }
      }
      GRAPHQL
  
      @payload = {
        "query" => @query,
        "variables" => {
          "ids" => @ids
        }
      }.to_json
    end
  
    def execute()
      @http_client.post("/graphql", headers: HTTP::Headers{"Content-Type" => "application/json"}, body: @payload)
    end
  end
end
