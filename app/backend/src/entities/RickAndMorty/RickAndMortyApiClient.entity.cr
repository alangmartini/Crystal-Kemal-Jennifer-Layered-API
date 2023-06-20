require "../HttpClient.entity"

# class QueryResponse
#   getter data: String
# end

class RickAndMortyApiClient
  def initialize(@ids : Array(Int64))
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
