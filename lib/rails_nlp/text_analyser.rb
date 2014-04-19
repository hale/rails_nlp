require 'sanitize'

module RailsNlp
  class TextAnalyser

    STOP_WORDS = ['a','able','about','across','after','all','almost','also','am','among','an','and','any','are','as','at','be','because','been','but','by','can','cannot','could','dear','did','do','does','either','else','ever','every','for','from','get','got','had','has','have','he','her','hers','him','his','how','however','i','if','in','into','is','it','its','just','least','let','like','likely','may','me','might','most','must','my','neither','no','nor','not','of','off','often','on','only','or','other','our','own','rather','said','say','says','she','should','since','so','some','than','that','the','their','them','then','there','these','they','this','tis','to','too','twas','us','wants','was','we','were','what','when','where','which','while','who','whom','why','will','with','would','yet','you','your']

    def initialize(model: model, fields: fields)
      @model = model
      @fields = fields
    end

    def analyse
      clean_words = sanitized_text.split.select do |raw_word|
        RailsNlp.spell_checker.correct?(raw_word)
      end - stop_words

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

      def stop_words
        STOP_WORDS + STOP_WORDS.map(&:capitalize)
      end


  end
end
