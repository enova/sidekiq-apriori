require 'spec_helper'
require 'sidekiq-apriori/middleware/prioritizer'

describe Sidekiq::Apriori, 'client middleware' do
  before do
    allow(Sidekiq).to receive(:server?).and_return(false)

    Sidekiq.configure_client do |config|
      config.client_middleware do |chain|
        chain.remove Sidekiq::Apriori::Prioritizer
      end
    end

  end

  it "should include Sidekiq::Apriori::Prioritizer in client middleware" do
    expect(Sidekiq.client_middleware.entries).to be_empty

    expect(require 'sidekiq-apriori/middleware/client').to eq(true)

    expect(Sidekiq.client_middleware.entries).not_to be_empty
    expect(Sidekiq.client_middleware.entries.map(&:klass)).to(
      include(Sidekiq::Apriori::Prioritizer)
    )
  end
end
