require 'active_record'
require 'sidekiq-apriori/arb'
require 'sqlite3'

ActiveRecord::Base.establish_connection(
  :adapter   => :sqlite3,
  :database  => 'spec/support/test.db'
)

ActiveRecord::Schema.define do
  drop_table(:arbs) rescue nil
  create_table(:arbs) { |t| t.column(:priority, :string) }
end

class Arb < ActiveRecord::Base
  include Sidekiq::Apriori::Arb
end

class PrioritizedUsingMethod < Arb
  prioritize using: :some_method
end

class PrioritizedUsingCallable < Arb
  prioritize do
    self.some_other_method
  end
end
