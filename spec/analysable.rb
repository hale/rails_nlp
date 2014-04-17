class Analysable < ActiveRecord::Base
  include RailsNlp
end

RailsNlp.configure do |config|
  config.model_name = "analysable"
  config.fields = ["title", "content"]
end
