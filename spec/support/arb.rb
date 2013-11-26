require 'active_record'
require 'sqlite3'

ActiveRecord::Base.establish_connection(
  :adapter => :sqlite3,
  :database => 'spec/support/test.db'
)

ActiveRecord::Schema.define do
  drop_table :arbs

  create_table :arbs do |t|
    t.column :priority, :string
  end
end

class Arb < ActiveRecord::Base
  include Sidekiq::Apriori
end
