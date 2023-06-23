require "../../entities/TravelPlans/TravelStopsJSON.entity"

# Helper methods used in `TravelPlansController`
module HelperTravelPlansController
  # Methods for handling `HTTP::Request` bodies (and `IO`s).
  # 
  # Although benchmarks show that JSONParse its the fastest method,
  # unserializer returns a TravelStopsJSON object,
  # that is more clean code compliant.
  #
  # For an 10milion big array:
  #
  # JSONParse: 1.5s, buffer: 4.94s, unserializer: 1.09s
  module BodyParser
    # Uses JSON.parse for handling `IO`s.
    def self.read_travel_stops_from_body_with_JSONparse(
      env_request_body : IO
      ) : Array(Int32)
        data = JSON.parse(env_request_body)
        

        travel_stops = data["travel_stops"].as_a.map do |int|
          int.as_i
        end

        travel_stops
    end

    # Transforms IO directly to `TravelStopsJSON`object
    # using `JSON::Serializable` unserializer.
    def self.read_travel_stops_from_body_with_unserializer(
      env_request_body : IO
      ) : TravelStopsJSON
        TravelStopsJSON.from_json(env_request_body)
    end

    # Reads the body in chunks to avoid using too much memory at once.
    # Its possible to increase the buffer size to improve performance.
    def self.read_travel_stops_from_body_with_buffer(
      env_request_body : IO
      ) : Array(Int32) | NamedTuple(message: String)
      # Read the data in chunks to avoid using too much memory at once.
        buffer = Bytes.new(8192) # 8 KB buffer
        data = ""
      
        while (read_bytes = env_request_body.read(buffer)) > 0
          data += String.new(buffer[0, read_bytes])
        end

        travel_stops_json = NamedTuple(travel_stops: Array(Int32))
        travel_stops_json.from_json(data)["travel_stops"]
    end
  end

    # Facilitates the creation of a Request response.
    #
    # ```
    # set_response_json("message", 200, env)
    # ```
    #
    # **note:** env is a `HTTP::Server::Context` object
    # served by `Kemal` on routes.
    def self.set_response_json(message : String, status_code : Int32, env : HTTP::Server::Context)
      env.response.content_type = "application/json"
      env.response.status_code = status_code
  
      {
        message: message,
        status_code: status_code
      }.to_json
    end
end