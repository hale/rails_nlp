require 'sanitize'

module RailsNlp
  class TextAnalyser

    def initialize(model: model, fields: fields)
      @model = model
      @fields = fields
    end

    def analyse
      clean_words = sanitized_text.split.select do |raw_word|
        RailsNlp.spell_checker.correct?(raw_word)
      end

      wordcounts = word_frequency(clean_words)

      wordcounts.each do |word, frequency|
        kw = Keyword.find_or_create_by(name: word.downcase)
        Wordcount.create do |wc|
          wc.analysable_id = @model.id
          wc.keyword_id = kw.id
          wc.count = frequency
        end
      end
    end

    private

    def sanitized_text
      "".tap do |str|
        @fields.each do |field|
          field_contents = @model.send(field)
          if field_contents
            field_contents = sanitize_html(field_contents)
            str << " " + field_contents
          end
        end
      end
    end

    def sanitize_html(str)
      Sanitize.clean(str)
    end

    def word_frequency(word_list)
      word_list.each_with_object(Hash.new(0)) do |word, counts|
        counts[word] += 1
      end
    end

  end
end
