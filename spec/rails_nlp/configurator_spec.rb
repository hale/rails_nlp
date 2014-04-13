require 'spec_helper'

module RailsNlp
  describe Configurator do
    it "stores the model name" do
      expect(Configurator.new(model_name: "Article").model_name).to eq("article")
    end

    it "stores the fields on the model which are analysed" do
      conf = Configurator.new(model_name: "", fields: [:title, :excerpt])
      expect(conf.fields).to eq([:title, :excerpt])
    end
  end
end
