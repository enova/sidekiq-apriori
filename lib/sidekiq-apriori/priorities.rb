module Sidekiq
  module Apriori
    PRIORITIES = [
      'immediate',
      'high',
      nil,
      'low'
    ].freeze unless defined?(PRIORITIES)
  end
end
