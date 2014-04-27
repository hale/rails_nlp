module RailsNlp
  class Query

    attr_reader :query

    def initialize(query)
      @query = query
    end

    def to_s
      @query
    end

    def keywords
      @keywords ||= (@query.split - RailsNlp.suggest_stopwords).join(" ")
    end

    def metaphones
      [].tap do |metaphones|
        keywords.split.each do |word|
          metaphones << Text::Metaphone.double_metaphone(word).first
        end
      end.join(" ")
    end

    def stems
      [].tap do |stems|
        keywords.split.each do |word|
          stems << Text::PorterStemming.stem(word)
        end
      end.join(" ")
    end

    def correct?
      @query.split.all? { |term| RailsNlp.spell_checker.correct?(term) }
    end

    def corrected
      @corrected ||= "".tap do |corrected|
        @query.split.each do |term|
          corrected << RailsNlp.spell_checker.suggest(term)
          corrected << " "
        end
      end.strip
    end

  end
end
