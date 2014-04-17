require 'active_record'

module RailsNlp
  class Keyword < ActiveRecord::Base
    #has_many :wordcounts
    #has_many :analysables, through: :wordcounts
  end
end
