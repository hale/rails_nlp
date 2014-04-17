require 'spec_helper'

module RailsNlp
  describe RailsNlp do
    it "gives a list of Keywords for this model" do
      model = create(:analysable, title: "the dog", content: "a ball")
      expect(model.keywords.pluck(:name)).to eq(["dog", "ball"])
    end
  end
end
