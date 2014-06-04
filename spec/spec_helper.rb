require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require_relative '../lib/rails_nlp'
require_relative 'analysable'

require 'factory_girl_rails'
require_relative 'factories.rb'
require 'shoulda/matchers'

RSpec.configure do |config|
  config.order = "random"
  config.tty = true
  config.mock_with :flexmock
  config.include FactoryGirl::Syntax::Methods
  config.around do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
  config.before(:all) do
    flexmock(BrontoGem).should_receive(:lookup).and_return({}).by_default
  end
end

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => ':memory:'
)

ActiveRecord::Schema.define do
  self.verbose = false


  create_table :wordcounts, force: true do |t|
    t.integer "analysable_id"
    t.integer "keyword_id"
    t.integer "count"
  end

  create_table :keywords, force: true do |t|
    t.string "name"
    t.string "metaphone"
    t.string "stem"
    t.text "synonyms"
  end

  create_table :analysables, force: true do |t|
    t.string "title"
    t.text "content"
  end
end
