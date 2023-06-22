require "../services/TravelPlansService.service"
require "../entities/TravelPlans/TravelStopsJSON.entity"

class TravelPlansController
  @TravelPlansService : AbstractTravelPlanService

  # Initialize the correspondet Service to utilize
  def initialize
    @TravelPlansService = TravelPlansService.new()
  end

  # Reads the Body from a `HTTP::Request` or any IO.
  # JSON.parse() is a more convenient (and faster) way,
  # but reading in chunks is more memory efficient for long bodies.
  # Also allows to handle as a string instead of JSON::Any.
  def read_travel_stops_from_body_with_JSONparse(
    env_request_body : IO
    )
      data = JSON.parse(env_request_body)
      

      travel_stops = data["travel_stops"].as_a.map do |int|
        int.as_i
      end

      travel_stops
  end

  def read_travel_stops_from_body_with_unserializer(
    env_request_body : IO
    ) : TravelStopsJSON
      TravelStopsJSON.from_json(env_request_body)
  end

  #
  def read_travel_stops_from_body_with_buffer(
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

  # :nodoc:
  def set_response_json(message : String, status_code : Int32, env : HTTP::Server::Context)
    env.response.content_type = "application/json"
    env.response.status_code = status_code

    {
      message: message,
      status_code: status_code
    }.to_json
  end

  # Create new TravelPlan. Used in POST /travel_plans
  def create_travel_plan(env : HTTP::Server::Context)
    if env.request.headers["Content-Length"] == "0"
      return set_response_json(
          "Travel Stops are required", 400, env
        )
    end

    travel_stops_body : IO | Nil = env.request.body

    if travel_stops_body
      # You can use any of the following methods to read the body
      # travel_stops = travel_stops_from_body_with_buffer
      # read_travel_stops_from_body_with_JSONparse

      # Although benchmarks show that JSONParse its the fastest method,
      # this method returns a TravelStopsJSON object,
      # that is more clean code compliant.
      # For an 10milion big array:
      # JSONParse: 1.5s, buffer: 4.94s, unserializer: 1.09s
      
      travel_stops : TravelStopsJSON =
        read_travel_stops_from_body_with_unserializer(
          travel_stops_body
      )
    end

    # puts typeof(travel_stops_body_2.to_s)
    # puts JSON.parse(travel_stops_body_2 || "oloco")
    # puts travel_stops_body_2.to_s

    begin
      # created_travel_plan = @TravelPlansService
      #   .create_travel_plan(travel_stops_body)
      # return created_travel_plan
    rescue e
      puts e.message
      return set_response_json("error", 400, env)
    end
  end
end