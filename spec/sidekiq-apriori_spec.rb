require 'spec_helper'

describe Sidekiq::Apriori do
  before(:all) do
    ## See spec/support/arb.rb for Arb class definition
    class Prioritized < Arb
      prioritize using: :some_method
    end
  end

  let(:arb)           { Arb.new  }
  let(:prioritized)   { Prioritized.new }

  it "should validate priorities" do
    arb.priority = "none"
    arb.should be_invalid

    Sidekiq::Apriori::PRIORITIES.each do |priority|
      arb.priority = priority
      arb.should be_valid
    end
  end

  it "should attempt prioritization on creation with named prioritizer" do
    prioritized.should_receive(:some_method)
    prioritized.save
  end

  describe Sidekiq::Apriori::Prioritizer do
    subject(:middleware)  { Sidekiq::Apriori::Prioritizer.new }

    let(:message)         { {'args' => [1, nil, 'high'], 'queue' => 'foo'} }
    let(:queue)           { 'foo' }

    describe '#call' do
      it 'should respond' do
        middleware.respond_to?(:call).should be_true
      end

      it 'should require three arguments' do
        expect { middleware.call }.
          to raise_error( ArgumentError,'wrong number of arguments (0 for 3)')
      end

      it 'should set priority queue' do
        middleware.call(nil, message, queue) {}
        message['queue'].should eql('foo_high')
      end

      it 'should allow only one priority suffix' do
        message['queue'] = 'foo_low_high_immediate'
        middleware.call(nil, message, queue) {}
        message['queue'].should eql('foo_high')

        middleware.call(nil, message, queue) {}
        message['queue'].should eql('foo_high')
      end
    end
  end
end
