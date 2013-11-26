require 'sidekiq-apriori/version'
require 'sidekiq-apriori/middleware'
require 'sidekiq-apriori/arb.rb'

module Sidekiq::Apriori
  PRIORITIES = [
    'immediate',
    'high',
    nil,
    'low'
  ].freeze unless defined?(PRIORITIES)
end
