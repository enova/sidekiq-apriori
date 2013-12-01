require 'spec_helper'
require 'sidekiq-apriori/middleware/prioritizer'

describe Sidekiq::Apriori, 'server middleware' do
  before do
    Sidekiq.stub(:server? => true)

    Sidekiq.configure_server do |config|
      config.client_middleware do |chain|
        chain.remove Sidekiq::Apriori::Prioritizer
      end
    end

  end

  it "should include Sidekiq::Apriori::Prioritizer in client middleware" do
    Sidekiq.client_middleware.entries.should be_empty

    (require 'sidekiq-apriori/middleware/server').should be_true

    Sidekiq.client_middleware.entries.should_not be_empty
    Sidekiq.client_middleware.entries.map(&:klass).
      should be_include(Sidekiq::Apriori::Prioritizer)
  end
end
