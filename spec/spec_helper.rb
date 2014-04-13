require_relative '../lib/rails_nlp'

RSpec.configure do |config|
  config.order = "random"
  config.color_enabled = true
  config.tty = true
  config.mock_with :flexmock
end
