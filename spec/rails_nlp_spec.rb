require 'spec_helper'

module RailsNlp
  describe RailsNlp do
    it "gives a list of Keywords for this model" do
      model = create(:analysable, title: "the dog", content: "a ball")
      expect(model.keywords.pluck(:name)).to eq(["dog", "ball"])
    end

    it "keywords for model are sanitized" do
      model = create(:analysable, title: "<h1>Header</h1><!-- msg -->",
                     content: "\nThis is a new\tbit of content")
      expect(model.keywords.pluck(:name)).to eq(%w(header new bit content))
    end

  end
end
