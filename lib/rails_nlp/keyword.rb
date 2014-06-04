require 'active_record'
require 'text'

module RailsNlp
  class Keyword < ActiveRecord::Base
    validates_presence_of :name
    validates_uniqueness_of :name

    before_create :set_metaphone, :set_stem, :set_synonyms

    has_many :wordcounts

    scope :orphans, -> {
      includes(:wordcounts).where('wordcounts.id IS NULL').references(:wordcounts)
    }

    serialize :synonyms

    private

    def set_metaphone
      self.metaphone = Text::Metaphone.double_metaphone(name).first
    end

    def set_stem
      self.stem = Text::PorterStemming.stem(name)
    end

    def set_synonyms
      self.synonyms = []
    end
  end
end
