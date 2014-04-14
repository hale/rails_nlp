require_relative '../lib/rails_nlp'
require_relative 'analysable_mock'
require 'factory_girl_rails'
require_relative 'factories.rb'

RSpec.configure do |config|
  config.order = "random"
  config.color_enabled = true
  config.tty = true
  config.mock_with :flexmock
  config.include FactoryGirl::Syntax::Methods
  config.around do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
end

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => ':memory:'
)

ActiveRecord::Schema.define do
  self.verbose = false

  create_table :keywords, force: true do |t|
    t.string "name"
    t.integer "analysable_id"
  end

  create_table :analysable_mocks, force: true do |t|
    t.string "title"
    t.text "content"
  end
end
