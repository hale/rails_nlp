module RailsNlp
  class Configurator
    attr_reader :model_name, :fields

    def initialize(model_name: model_name, fields: fields)
      @model_name = model_name.downcase
      @fields = fields
    end
  end
end
