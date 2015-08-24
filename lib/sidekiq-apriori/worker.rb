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
      extract_priority!(args.last)
      super(*args)
    rescue ArgumentError => err
      raise err unless has_declared_priority?
      super(*args[0..-2])
    end

    def with_priority
      yield(@apriori_priority_args.last)
    end

    def has_declared_priority?
      @apriori_priority_args.first
    end
    private :has_declared_priority?

    def extract_priority!(options)
      @apriori_priority_args = []

      return unless hashlike?(options)
      s_opts = stringify_keys(options)

      @apriori_priority_args = [
        s_opts.has_key?('priority'),
        s_opts['priority']
      ]
    end
    private :extract_priority!

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
