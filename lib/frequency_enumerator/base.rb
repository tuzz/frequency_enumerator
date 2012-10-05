class FrequencyEnumerator < Enumerable::Enumerator

  attr_reader :frequencies, :bit_count, :from, :to

  def initialize(frequencies, params = {})
    @frequencies = frequencies

    @bit_count  = params[:bit_count]  || 6
    @from       = params[:from]       || 0
    @to         = params[:to]         || limit

    raise_if_either_boundary_is_out_of_range

    @sorter     = params[:sorter]     || fe::Sorter
    @composer   = params[:composer]   || fe::Composer
    @decomposer = params[:decomposer] || fe::Decomposer
  end

  def each(&block)
    (from..to).each do |i|
      binary = decomposer.decompose(i)
      bitmap = fragmented_bitmap(binary)
      yield composition(bitmap)
    end

    self
  end

  def limit
    @limit ||= (2 ** bit_count) ** frequencies.size - 1
  end

  private
  def decomposer
    @decomposer.new(:bit_count => @bit_count * frequencies.size)
  end

  def fragmented_bitmap(binary)
    pairs = binary.zip(sorted_keys)
    empty_array_default = Hash.new { |h, k| h[k] = [] }

    pairs.inject(empty_array_default) do |h, (bit, key)|
      h[key] << bit; h
    end
  end

  def composition(bitmap)
    bitmap.inject({}) do |h, (key, fragment)|
      h.merge(key => @composer.compose(fragment))
    end
  end

  def sorted_keys
    return @sorted_keys if @sorted_keys
    sorter = @sorter.new(:bit_count => @bit_count)
    @sorted_keys = sorter.sort(frequencies)
  end

  def raise_if_either_boundary_is_out_of_range
    [@from, @to].each do |i|
      raise ArgumentError.new(
        "#{i} lies outside of the range of the function: (0..#{limit})."
      ) if out_of_range?(i)
    end
  end

  def out_of_range?(x)
    x < 0 || x > limit
  end

  def fe
    self.class
  end

end
