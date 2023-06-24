require 'benchmark'
require 'securerandom'
require 'active_support'
require 'active_support/core_ext'

class IndependentResearch
  ARRAY_COUNT = 1_000_000
  STR_ARRAY = ARRAY_COUNT.times.inject([]) { |result, _| result.push(SecureRandom.alphanumeric) }

  def initialize
    @test_array_for_original = STR_ARRAY
  end

  def self.test(pattern_name, &)
    puts pattern_name
    new.test(&)
  end

  def benchmark(title)
    test_array = @test_array_for_original.deep_dup
    Benchmark.benchmark(Benchmark::CAPTION, 7, Benchmark::FORMAT) do |x|
      x.report(title) do
        yield(test_array)
      end
    end
  end

  def test(&)
    benchmark('map:') do |test_array|
      test_array.map(&)
    end

    benchmark('map!:') do |test_array|
      test_array.map!(&)
    end
  end
end

IndependentResearch.test('メモリ領域を広げない編集', &:upcase!)
IndependentResearch.test('メモリ領域を固定長、狭める編集') { |value| value[0, 3] }
IndependentResearch.test('メモリ領域を固定長、広げる編集') { |value| "#{value}A" }
IndependentResearch.test('メモリ領域を可変長、広げる編集') { |value| "#{value}#{'A' * rand(10)}" }
