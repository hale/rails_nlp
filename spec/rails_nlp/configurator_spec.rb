require 'spec_helper'

module RailsNlp
  describe Configurator do
    it "can set the model name from other objects" do
      Configurator.model_name = "book"
      expect(Configurator.model_name).to eq("book")
    end

    it "can set the analysed fields from other objects" do
      Configurator.fields = ["title", "author"]
      expect(Configurator.fields).to eq(["title", "author"])
    end
  end
end
