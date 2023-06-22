abstract class AbstractBenchmark
  abstract def run(proc1 : Proc(IO, Array(Int32)), proc2 : Proc(IO, Array(Int32)))
end