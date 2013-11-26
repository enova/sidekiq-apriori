require 'sidekiq'
require 'sidekiq-apriori/prioritizer'

Sidekiq.configure_client do |config|
  config.client_middleware do |chain|
    chain.add Sidekiq::Apriori::Prioritizer
  end
end

Sidekiq.configure_server do |config|
  config.client_middleware do |chain|
    chain.add Sidekiq::Apriori::Prioritizer
  end
end
