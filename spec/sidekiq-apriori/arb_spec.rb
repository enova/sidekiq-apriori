require 'spec_helper'
require 'sidekiq-apriori/arb'

describe Sidekiq::Apriori::Arb do

  ## See spec/support/arb.rb for Arb class definition
  require 'support/arb'

  let(:arb)             { Arb.new  }
  let(:using_method)    { PrioritizedUsingMethod.new }
  let(:using_callable)  { PrioritizedUsingCallable.new }

  it "should validate priorities" do
    arb.priority = "none"
    expect(arb).to be_invalid

    Sidekiq::Apriori::PRIORITIES.each do |priority|
      arb.priority = priority
      expect(arb).to be_valid
    end
  end

  it "should attempt prioritization on creation with named prioritizer" do
    expect(using_method).to receive(:some_method)
    using_method.save
  end

  it "should attempt prioritization on creation with using a block" do
    expect(using_callable).to receive(:some_other_method)
    using_callable.save
  end
end
