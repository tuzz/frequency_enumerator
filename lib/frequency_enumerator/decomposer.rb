class FrequencyEnumerator::Decomposer

  class ::OverflowError < StandardError; end
  class ::SignedError   < StandardError; end

  attr_reader :bit_count
  attr_reader :endianness

  def initialize(params = {})
    @bit_count  = params[:bit_count]  || 6
    @endianness = params[:endianness] || :little
  end

  def self.decompose(integer)
    new.decompose(integer)
  end

  def decompose(integer)
    raise_if_negative(integer)
    raise_if_not_enough_bits(integer)

    bit_array = bit_count.times.map { |b| integer[b] }

    little_endian? ? bit_array : bit_array.reverse
  end

  def little_endian?
    endianness == :little
  end

  def big_endian?
    endianess == :big
  end

  private
  def raise_if_negative(integer)
    raise SignedError.new(
      "Decomposing negative integers is unsupported."
    ) if integer < 0
  end

  def raise_if_not_enough_bits(integer)
    bits_required = bits_required_to_decompose(integer)

    raise OverflowError.new(
      "Decomposing #{integer} requires more than #{bit_count} bits."
    ) if bits_required > bit_count
  end

  def bits_required_to_decompose(integer)
    (1..1.0/0).detect do |bits|
      (integer >> bits).zero?
    end
  end

end
