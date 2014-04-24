module RailsNlp
  class Configuration

    attr_accessor :fields, :model_name

    def method_missing(m)
      nil
    end

  end
end
