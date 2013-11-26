module Sidekiq::Apriori
  def self.included(base)
    return unless defined?(ActiveRecord::Base) && base < ActiveRecord::Base

    base.extend ClassMethods

    ## Add validation for priority attribute
    if base.attribute_names.include?('priority')
      base.validates_inclusion_of :priority, :in => PRIORITIES
    end
  end

  module ClassMethods
    ## Declarative hook to prioritize instances
    def prioritize(options = {}, &block)
      method = ( block_given? && [-1, 0].include?(block.arity) ) ?
        block : ( options[:using] || options[:with] )

      before_validation method, :on => :create
    end
  end

end
