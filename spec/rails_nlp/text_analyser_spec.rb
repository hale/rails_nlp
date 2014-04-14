require 'spec_helper'

module RailsNlp
  describe TextAnalyser do
    it "fetches the fields from the config" do
      analysable = create(:analysable_mock)
      flexmock(Configurator).should_receive(:fields).once.and_return(["title"])
      TextAnalyser.analyse(analysable: analysable)
    end

    describe "creating a keyword records" do
      it "creates a keyword record" do
        analysable = create(:analysable_mock)
        expect{TextAnalyser.analyse(analysable: analysable)}.to change{Keyword.count}
      end

      it "keyword record contains id of model" do
        analysable = create(:analysable_mock)
        TextAnalyser.analyse(analysable: analysable)
        expect(Keyword.last.analysable_id).to eq(analysable.id)
      end

      it "Keyword#name for each keyword created is a word from analysable fields" do
        analysable = create(:analysable_mock, title: "Ray Mars", content: "The end")
        TextAnalyser.analyse(analysable: analysable)
        expect(Keyword.pluck(:name)).to eq(%w(Ray Mars The end))
      end
    end
  end
end
