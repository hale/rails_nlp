require 'active_record'
require 'text'

module RailsNlp
  class Keyword < ActiveRecord::Base
    validates_presence_of :name
    validates_uniqueness_of :name

    before_create :set_metaphone, :set_stem

    private

    def set_metaphone
      self.metaphone = Text::Metaphone.double_metaphone(name).first
    end

    def set_stem
      self.stem = Text::PorterStemming.stem(name)
    end
  end
end
