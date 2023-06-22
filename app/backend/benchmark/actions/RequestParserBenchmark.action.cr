require "benchmark"
require "../abstracts/absBenchmark.abstract.cr"

require "../../src/controllers/TravelPlansController.controller"

class RequestParserBenchmark < AbstractBenchmark
  @TravelPlansController = TravelPlansController.new
  def initialize()
  end

  def run()
    large_array = Array.new(10_000_000) { rand(1..100) }
    mock_body = IO::Memory.new({
      "travel_stops": large_array
    }.to_json)

    method1 = ->(
      env_request_body : IO
      ) { @TravelPlansController
        .read_travel_stops_from_body_with_JSONparse(env_request_body)
      }

    method2 = ->(
      env_request_body : IO
      ) { @TravelPlansController
        .read_travel_stops_from_body_with_buffer(env_request_body)
      }

    method3 = ->(
      env_request_body : IO
    ) { @TravelPlansController
      .read_travel_stops_from_body_with_unserializer(env_request_body)
    }

    benchmark_body_parsing(
      mock_body,
      method1,
      method2,
      method3,
    )
  end

  def benchmark_body_parsing(
    env_request_body : IO,
    proc1,
    proc2,
    proc3,
    )
    Benchmark.bm do |x|
      x.report("With JSON.parse") do
        env_request_body.rewind # Ensure we read from the beginning
        proc1.call(env_request_body)
      end
    
      x.report("With buffer") do
        env_request_body.rewind # Ensure we read from the beginning
        proc2.call(env_request_body)
      end
    
      x.report("With unserializer") do
        env_request_body.rewind # Ensure we read from the beginning
        proc3.call(env_request_body)
      end
    end
  end
end


