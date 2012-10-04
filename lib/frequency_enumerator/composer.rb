class FrequencyEnumerator::Composer

  attr_reader :endianess

  def initialize(params = {})
    @endianess = params[:endianess]
  end

  def self.compose(bit_array)
    new.compose(bit_array)
  end

  def compose(bit_array)
    raise_if_non_binary_elements(bit_array)

    bit_array = bit_array.reverse if big_endian?

    bit_array.each_with_index.inject(0) do |sum, (bit, index)|
      sum + (bit << index)
    end
  end

  def little_endian?
    @endianess == :little
  end

  def big_endian?
    @endianess == :big
  end

  private
  def raise_if_non_binary_elements(bit_array)
    non_binary_elements = bit_array.reject { |b| [0, 1].include?(b) }

    if non_binary_elements.any?
      plural = 's' if non_binary_elements.size > 1
      elements = non_binary_elements.map(&:inspect).join(', ')

      raise TypeError.new(
        "Composing from non-binary element#{plural} #{elements}."
      )
    end
  end

end
