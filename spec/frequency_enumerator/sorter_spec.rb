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
