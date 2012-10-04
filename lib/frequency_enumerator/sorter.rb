class FrequencyEnumerator::Sorter

  def initialize

  end

  def self.sort(frequencies)
    new.sort(frequencies)
  end

  def sort(frequencies)
    Helper.new(frequencies).help
  end

  class Helper < Struct.new(:frequencies)

    def help

    end

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
