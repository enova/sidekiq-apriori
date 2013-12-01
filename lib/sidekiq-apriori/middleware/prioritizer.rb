require 'sidekiq-apriori/priorities'

module Sidekiq::Apriori
  class Prioritizer
    def call(worker, msg, queue)
      options   = msg["args"].last if msg["args"].respond_to?(:last)
      priority  = options[:priority] if options.is_a?(Hash) && options.has_key?(:priority)

      if priorities.include?(priority)
        msg["queue"] = queue.to_s.sub(priority_regexp,"_#{priority}")
      end

      yield
    end

    def priorities
      Sidekiq::Apriori::PRIORITIES.compact
    end

    def priority_regexp
      /(_(#{priorities.join('|')}))*$/
    end
  end
end
