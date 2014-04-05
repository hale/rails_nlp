require_relative '../lib/rails_nlp'
require_relative '../lib/keyword'
require_relative '../lib/wordcount'

RSpec.configure do |config|
  config.order = "random"
  config.color_enabled = true
  config.tty = true
end
