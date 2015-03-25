require 'fakeredis/rspec'
require 'sidekiq'
require 'sidekiq/testing'

require 'simplecov'

SimpleCov.start do
  add_filter "vendor"
  add_filter "spec"
end

require 'sidekiq-apriori/priorities'

redis = { :url => "redis://localhost:6379/0",
          :driver => Redis::Connection::Memory  }

Sidekiq.configure_client { |config| config.redis = redis }
Sidekiq.configure_server do |config|
  config.redis = redis

  # require 'support/tracked_fetch'
  # Sidekiq.options[:fetch] = TrackedFetch
end

RSpec.configure do |config|
  config.before(:each) do |example|
    ## Use metadata to determine testing behavior
    ## for queuing.
    Sidekiq::Worker.clear_all

    case example.metadata[:queuing].to_s
    when 'enable', 'enabled', 'on', 'true'
      Sidekiq::Testing.disable!
    when 'fake', 'mock'
      Sidekiq::Testing.fake!
    when 'inline'
      Sidekiq::Testing.inline!
    else
      defined?(Redis::Connection::Memory) ?
        Sidekiq::Testing.disable! : Sidekiq::Testing.inline!
    end
  end
end
