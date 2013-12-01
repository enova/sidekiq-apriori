require 'sidekiq-apriori/middleware/prioritizer'

Sidekiq.configure_client do |config|
  config.client_middleware do |chain|
    chain.add Sidekiq::Apriori::Prioritizer
  end
end
