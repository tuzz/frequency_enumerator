require 'spec_helper'

describe FrequencyEnumerator::Sorter do

  let(:klass) { subject.class }

  it 'sorts a frequency distribution by probability of repeated occurence' do
    klass.sort(:a => 4, :b => 6).should == [
      :b, # 0.4, 0.36
      :a, # 0.16, 0.36
      :b, # 0.16, 0.216
      :b, # 0.16, 0.1296
      :a, # 0.064, 0.1296
      :b, # 0.064, 0.07776
      :b, # 0.064, 0.046656
      :a, # 0.0256, 0.046656
      :b, # 0.0256, depleted (6 bits default)
      :a, :a, :a
    ]

    klass.sort(:a => 0.1, :b => 0.5, :c => 0.4).should == [
      :b, # 0.1, 0.25, 0.4
      :c, # 0.1, 0.25, 0.16
      :b, # 0.1, 0.125, 0.16
      :c, # 0.1, 0.125, 0.064
      :b, # 0.1, 0.0625, 0.064
      :a, # 0.01, 0.0625, 0.064
      :c, # 0.01, 0.0625, 0.0256
      :b, # 0.01, 0.03125, 0.0256
      :b, # 0.01, 0.015625, 0.0256
      :c, # 0.01, 0.015625, 0.01024
      :b, # 0.01, depleted, 0.01024
      :c, # 0.01,           0.004096
      :a, # 0.001,          0.004096
      :c, # 0.001,          depleted
      :a, :a, :a, :a
    ]
  end

end

describe FrequencyEnumerator::Sorter::Helper do

  let(:klass) { subject.class }

  describe '#probabilities' do
    it 'returns a hash of probabilities for the given frequencies' do
      klass.new(:a => 2, :b => 4, :c => 1, :d => 3).probabilities.should == {
        :a => 0.2, :b => 0.4, :c => 0.1, :d => 0.3
      }

      klass.new(:a => 2, :b => 3, :c => 0).probabilities.should == {
        :a => 0.4, :b => 0.6, :c => 0
      }
    end

    it 'is pure' do
      frequencies = { :a => 1, :b => 2 }.freeze
      expect { klass.new(frequencies).probabilities }.to_not raise_error

      klass.new(frequencies).probabilities.should == klass.new(frequencies).probabilities
    end
  end

  describe '#accumulation' do
    it 'defaults to the probability hash' do
      klass.new(:a => 1, :b => 1).accumulation.should == { :a => 0.5, :b => 0.5 }
    end

    it 'does not mutate the probability hash' do
      instance = klass.new(:a => 1, :b => 1)
      instance.accumulation[:a] = :mutated
      instance.probabilities[:a].should == 0.5
    end
  end

  describe '#accumulate' do
    it 'multiplies the accumulation value for the given key by the respective probability' do
      instance = klass.new(:a => 1, :b => 3)

      instance.accumulate(:a)
      instance.accumulation[:a].should == 0.25 ** 2

      5.times { instance.accumulate(:b) }
      instance.accumulation[:b].should == 0.75 ** 6
    end
  end

end
