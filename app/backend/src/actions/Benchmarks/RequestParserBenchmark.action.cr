require "benchmark"
require "../abstract/absBenchmark.abstract"

class RequestParserBenchmark < AbstractBenchmark
  def initialize(@env_request_body : IO)
  end

  def run(proc1 : Proc(IO, Array(Int32)), proc2 : Proc(IO, Array(Int32)))
    Benchmark.bm do |x|
      x.report("With JSON.parse") do
        @env_request_body.rewind # Ensure we read from the beginning
        proc1.call(@env_request_body)
      end

      x.report("With buffer") do
        @env_request_body.rewind # Ensure we read from the beginning
        proc2.call(@env_request_body)
      end
    end
  end
end