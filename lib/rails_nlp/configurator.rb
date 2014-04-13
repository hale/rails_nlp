module RailsNlp
  class Configurator

    def self.model_name=(model_name)
      @@model_name = model_name
    end

    def self.fields=(fields)
      @@fields = fields
    end

    def self.model_name
      @@model_name
    end

    def self.fields
      @@fields
    end

  end
end
