module RailsNlp
  class Keyword < ActiveRecord::Base

    serialize :metaphone, Array
    serialize :synonyms, Array

    has_many :wordcounts
    has_many :associations, :through => :wordcounts

    after_create :analyse

    # TODO: use SQL for much faster results.
    def count
      self.wordcounts.map(&:count).inject(0, :+)
    end

    def analyse
      # TODO: use validations instead
      raise "Cannot analyse keyword with no name" if self.name.blank?
      self.stem = Text::PorterStemming.stem( self.name )
      self.metaphone = Text::Metaphone.double_metaphone( self.name )
      self.synonyms = BigHugeThesaurus.synonyms( self.name )
      self.save
    end

    private

    def keyword_params
      params.require(:keyword).permit(:metaphone, :name, :stem, :synonyms)
    end

  end
end
