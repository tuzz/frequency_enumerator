require 'spec_helper'

describe FrequencyEnumerator::Composer do

  let(:klass) { subject.class }

  it 'composes an array of bits into an integer' do
    expectations = {
      0  => [0],
      1  => [1, 0],
      1  => [1, 0, 0],
      2  => [0, 1, 0, 0],
      3  => [1, 1, 0, 0, 0],
      5  => [1, 0, 1, 0, 0, 0],
      8  => [0, 0, 0, 1, 0, 0, 0],
      13 => [1, 0, 1, 1, 0, 0, 0, 0],
      21 => [1, 0, 1, 0, 1, 0, 0, 0, 0],
      34 => [0, 1, 0, 0, 0, 1, 0, 0, 0, 0]
    }

    expectations.each do |integer, bit_array|
      klass.compose(bit_array).should == integer
    end
  end

  it 'supports changing the endianess' do
    little_endian = klass.new(:endianess => :little)
    big_endian = klass.new(:endianess => :big)

    little_endian.compose([1, 1, 0]).should == 3
    big_endian.compose([1, 1, 0]).should == 6
  end

  it 'raises an exception if any element is non-binary' do
    expect {
      klass.compose([0, 1, 2])
    }.to raise_error(TypeError, 'Composing from non-binary element 2.')

    expect {
      klass.compose([1, 2, -3, :foo])
    }.to raise_error(TypeError, 'Composing from non-binary elements 2, -3, :foo.')
  end

  it 'is pure' do
    bit_array = [1, 0].freeze
    expect { klass.compose(bit_array) }.to_not raise_error

    klass.compose(bit_array).should == klass.compose(bit_array)
  end

end
