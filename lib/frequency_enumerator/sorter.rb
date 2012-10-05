class FrequencyEnumerator::Sorter

  attr_reader :bit_count

  def initialize(params = {})
    @bit_count = params[:bit_count] || 8
  end

  def self.sort(frequencies)
    new.sort(frequencies)
  end

  def sort(frequencies)
    helper = AccumulationHelper.new(frequencies, bit_count)
    sorted_keys = []

    until helper.depleted_keys? do
      key = helper.maximal_key
      sorted_keys << key
      helper.accumulate(key)
    end

    sorted_keys
  end

  class AccumulationHelper

    attr_reader :frequencies, :bit_count

    def initialize(frequencies, bit_count = 6)
      @frequencies = frequencies
      @bit_count = bit_count
    end

    def depleted_keys?
      available_keys.empty?
    end

    def maximal_key
      accumulation.max_by { |_, v| v }.first
    end

    def accumulate(key)
      accumulation[key] *= probabilities[key]
      consume(key)
    end

    def available_keys
      @available_keys ||= frequencies.inject({}) do |hash, (k, _)|
        hash.merge(k => bit_count)
      end
    end

    def accumulation
      @accumulation ||= probabilities.dup
    end

    def consume(key)
      available_keys[key] -= 1

      if available_keys[key].zero?
        available_keys.delete(key)
        accumulation.delete(key)
      end
    end

    def probabilities
      return @probabilities if @probabilities
      total = frequencies.values.inject(:+)
      @probabilities = frequencies.inject({}) do |hash, (k, v)|
        hash.merge(k => v.to_f / total)
      end
    end

  end

end
