module Sidekiq::Apriori
  class Prioritizer
    def call(worker, msg, queue)
      priority = msg["args"].try(:last)
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
