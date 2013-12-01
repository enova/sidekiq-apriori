module Sidekiq::Apriori
  module Worker
    def self.included(base)
      base.class_eval do
        include Sidekiq::Worker if defined?(Sidekiq::Worker)

        ## Prepend is only available for ruby > 2.0.0
        #
        version = RUBY_VERSION.split(/\./).map(&:to_i) rescue []
        prepend ClassMethods if version.first > 1
      end
    end
  end

  module ClassMethods
    def perform(*args)
      super(*args)
    rescue ArgumentError => err
      raise err unless has_priority?(args.last)
      super(*args[0..-2])
    end

    def has_priority?(options)
      return false unless hashlike?(options)
      stringify_keys(options).has_key?('priority')
    end
    private :has_priority?

    def stringify_keys(hashish)
      duplicate = hashish.dup

      if hashlike?(hashish)
        duplicate.keys.each do |key|
          duplicate[key.to_s] = duplicate.delete(key)
        end
      end

      duplicate
    end
    private :stringify_keys

    def hashlike?(hashish)
      [ :keys, :has_key?, :[] ].
        map { |method| hashish.respond_to?(method) }.all?
    end
    private :hashlike?

  end
end
