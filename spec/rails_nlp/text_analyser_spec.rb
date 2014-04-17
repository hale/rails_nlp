require 'spec_helper'

module RailsNlp
  describe TextAnalyser do
    describe "creating a keyword records" do
      it "creates a keyword record" do
        expect{create(:analysable)}.to change{Keyword.count}
      end

      it "is case insensitive" do
        TextAnalyser.analyse(create(:analysable, title: "alpha", content: ""))
        TextAnalyser.analyse(create(:analysable, title: "Alpha", content: ""))
        expect(Keyword.pluck(:name)).to eq(["alpha"])
      end

      it "removes stop words" do
        TextAnalyser.analyse(create(:analysable, title: "the dog is a good boy", content: ""))
        expect(Keyword.pluck(:name)).to eq(%w(dog good boy))
      end

      it "Keyword#name for each keyword created is a word from analysable fields" do
        create(:analysable, title: "Ray Mars", content: "The end")
        expect(Keyword.pluck(:name)).to eq(%w(ray mars end))
      end
    end
  end
end
