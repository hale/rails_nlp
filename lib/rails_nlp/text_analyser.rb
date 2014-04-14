module RailsNlp
  class TextAnalyser
    def self.analyse(analysable: analysable)
      Configurator.fields.each do |field|
        text = analysable.send(field)
        text.split.each do |word|
          Keyword.create(analysable_id: analysable.id, name: word)
        end
      end
    end
  end
end
