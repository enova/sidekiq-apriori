require 'spec_helper'
require 'sidekiq-apriori/middleware/prioritizer'

describe Sidekiq::Apriori::Prioritizer do
  subject(:middleware)  { Sidekiq::Apriori::Prioritizer.new }

  let(:queue)   { 'foo' }
  let(:message) { {'args' => [1, nil, priority: 'high'], 'queue' => queue } }

  describe '#call' do
    it 'should respond' do
      expect(middleware).to respond_to(:call)
    end

    it 'should require three arguments' do
      expect { middleware.call }.
        to raise_error( ArgumentError,'wrong number of arguments (0 for 3)')
    end

    it 'should set priority queue' do
      middleware.call(nil, message, queue) {}
      expect(message['queue']).to eq('foo_high')
    end

    it 'should allow only one priority suffix' do
      message['queue'] = 'foo_low_high_immediate'
      middleware.call(nil, message, queue) {}
      expect(message['queue']).to eq('foo_high')

      middleware.call(nil, message, queue) {}
      expect(message['queue']).to eq('foo_high')
    end
  end
end
