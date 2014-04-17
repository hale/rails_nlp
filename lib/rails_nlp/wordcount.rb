module RailsNlp
  class Wordcount < ActiveRecord::Base
    belongs_to :analysable
    belongs_to :keyword
  end
end
