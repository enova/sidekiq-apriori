module Sidekiq::Apriori
  module Worker
    def self.included(base)
      base.class_eval do
        include Sidekiq::Worker if defined?(Sidekiq::Worker)

        version = RUBY_VERSION.split(/\./).map(&:to_i) rescue []
        prepend ClassMethods if version.first > 1
      end
    end
  end

  module ClassMethods
    def perform(*args)
      retried = false

      begin
        super(*args)
      rescue ArgumentError => err
        raise err unless
          args.last.is_a?(Hash) && args.last.has_key?(:priority)

        args = args[0..-2]
        (retried = true ) && retry
      end
    end
  end
end
