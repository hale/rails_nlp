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
      (@query.split - RailsNlp.suggest_stopwords).join(" ")
    end

    def metaphones
      [].tap do |metaphones|
        @query.split.each do |word|
          metaphones << Text::Metaphone.double_metaphone(word).first
        end
      end.join(" ")
    end

    def stems
      [].tap do |stems|
        @query.split.each do |word|
          stems << Text::PorterStemming.stem(word)
        end
      end.join(" ")
    end

  end
end
