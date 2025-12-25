require "benchmark"
require "./src/types"

n = 1000

calculation = 1.seconds
warmup = 2.seconds

Benchmark.ips(calculation, warmup) do |x|
  x.report("Some()") do
    n.times do
      Some(Int32)[0]
    end
  end

  x.report("Some.new") do
    n.times do
      Some.new(0)
    end
  end

  x.report("None()") do
    n.times do
      None(Int32)[]
    end
  end

  x.report("None.new") do
    n.times do
      None(Int32).new
    end
  end
end

Benchmark.ips(calculation, warmup) do |x|
  x.report("Ok()") do
    n.times do
      Ok(Int32, Int32)[0]
    end
  end

  x.report("Ok.new") do
    n.times do
      Ok(Int32, Int32).new(0)
    end
  end

  x.report("Err()") do
    n.times do
      Err(Int32, Int32)[0]
    end
  end

  x.report("Err.new") do
    n.times do
      Err(Int32, Int32).new(0)
    end
  end
end
