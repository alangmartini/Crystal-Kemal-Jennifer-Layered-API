require "http/client"
require "json"

class HttpClient
  def initialize(@host : String, @tls : Bool = false)
    @client = HTTP::Client.new(@host, tls: @tls)
  end
 
  def post(endpoint : String, headers : HTTP::Headers, body : String) : JSON::Any
    response = @client.post(endpoint, headers: headers, body: body)
  
    JSON.parse(response.body)
  end
end