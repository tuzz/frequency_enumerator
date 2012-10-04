class FrequencyEnumerator::Sorter

  attr_reader :bit_count, :composer, :decomposer

  def initialize(bit_count = 6, composer = fe::Composer, decomposer = fe::Decomposer)
    @bit_count  = bit_count
    @composer   = composer.new(bit_count)
    @Decomposer = decomposer.new(bit_count)
  end

  def self.sort(frequencies)
    new.sort(frequencies)
  end

  def sort(frequencies)
    helper = AccumulationHelper.new(frequencies)
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
