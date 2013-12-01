require 'spec_helper'
require 'sidekiq-apriori/worker'

describe Sidekiq::Apriori::Worker do
  before(:all) do
    class Job
      def perform; end
      include Sidekiq::Apriori::Worker
    end
  end

  let(:job) { Job.new }

  ## Checking for ruby 2
  #
  if ( RUBY_VERSION.split(/\./).map(&:to_i) rescue [] ).first > 1
    it "redefines 'perform' to handle an extra argument when that argument has priority information" do
      job.should be_an_instance_of(Job)
      expect { job.perform(priority: "high") }.not_to raise_error
    end

    it "does not rescue errors with incorrectly formatted priority information" do
      expect { job.perform("high") }.to raise_error(ArgumentError)
      expect { job.perform({}) }.to raise_error(ArgumentError)
    end
  end
end
