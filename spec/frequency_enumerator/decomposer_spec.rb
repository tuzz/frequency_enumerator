require 'spec_helper'

describe FrequencyEnumerator::Decomposer do

  let(:klass) { subject.class }

  it 'decomposes an integer into an array of bits' do
    klass.decompose(0).should  == [0, 0, 0, 0, 0, 0, 0, 0]
    klass.decompose(10).should == [0, 1, 0, 1, 0, 0, 0, 0]
    klass.decompose(20).should == [0, 0, 1, 0, 1, 0, 0, 0]
    klass.decompose(30).should == [0, 1, 1, 1, 1, 0, 0, 0]
    klass.decompose(40).should == [0, 0, 0, 1, 0, 1, 0, 0]
  end

  it 'supports changing the default bit count of 6' do
    instance = klass.new(:bit_count => 4)

    instance.decompose(0).should  == [0, 0, 0, 0]
    instance.decompose(5).should  == [1, 0, 1, 0]
    instance.decompose(10).should == [0, 1, 0, 1]
  end

  it 'supports changing the endianness' do
    little_endian = klass.new(:endianness => :little)
    big_endian = klass.new(:endianness => :big)

    little_endian.decompose(3).should == [1, 1, 0, 0, 0, 0, 0, 0]
    big_endian.decompose(3).should == [0, 0, 0, 0, 0, 0, 1, 1]
  end

  it 'raises an exception on signed integers' do
    expect {
      klass.decompose(-1)
    }.to raise_error(SignedError, 'Decomposing negative integers is unsupported.')
  end

  it 'raises an exception on overflow' do
    expect {
      klass.decompose(9999)
    }.to raise_error(OverflowError, 'Decomposing 9999 requires more than 8 bits.')

    instance = klass.new(:bit_count => 2)
    expect {
      instance.decompose(4)
    }.to raise_error(OverflowError, 'Decomposing 4 requires more than 2 bits.')
  end

  it 'is pure' do
    integer = 5.freeze
    expect { klass.decompose(integer) }.to_not raise_error

    klass.decompose(integer).should == klass.decompose(integer)
  end

end
