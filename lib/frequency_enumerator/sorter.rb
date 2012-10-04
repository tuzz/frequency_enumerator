class FrequencyEnumerator::Sorter

  attr_reader :bit_count

  def initialize(params = {})
    @bit_count = params[:bit_count] || 6
  end

  def self.sort(frequencies)
    new.sort(frequencies)
  end

  def sort(frequencies)
    helper = AccumulationHelper.new(frequencies)
    remaining = availability_hash(frequencies)
    sorted_array = []

    until remaining.empty? do
      key = helper.maximal_key
      sorted_array << key

      helper.accumulate(key)
      consume(key, remaining, helper)
    end

    sorted_array
  end

  def availability_hash(frequencies)
    frequencies.inject({}) do |hash, (k, _)|
      hash.merge(k => bit_count)
    end
  end

  def consume(key, remaining, helper)
    remaining[key] -= 1

    if remaining[key].zero?
      remaining.delete(key)
      helper.accumulation.delete(key)
    end
  end

  private
  def fe
    FrequencyEnumerator
  end

  class AccumulationHelper < Struct.new(:frequencies)

    def maximal_key
      accumulation.max_by { |_, v| v }.first
    end

    def probabilities
      return @probabilities if @probabilities
      total = frequencies.values.inject(:+)
      @probabilities = frequencies.inject({}) do |hash, (k, v)|
        hash.merge(k => v.to_f / total)
      end
    end

    def accumulation
      @accumulation ||= probabilities.dup
    end

    def accumulate(key)
      accumulation[key] *= probabilities[key]
    end

  end

end
