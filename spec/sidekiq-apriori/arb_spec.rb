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
    arb.should be_invalid

    Sidekiq::Apriori::PRIORITIES.each do |priority|
      arb.priority = priority
      arb.should be_valid
    end
  end

  it "should attempt prioritization on creation with named prioritizer" do
    using_method.should_receive(:some_method)
    using_method.save
  end

  it "should attempt prioritization on creation with using a block" do
    using_callable.should_receive(:some_other_method)
    using_callable.save
  end
end
