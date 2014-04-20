require 'spec_helper'

module RailsNlp
  describe RailsNlp do
    it "gives a list of Keywords for this model" do
      model = create(:analysable, title: "the dog", content: "a ball")
      expect(model.keywords.pluck(:name)).to eq(%w(the dog a ball))
    end

    it "keywords for model are sanitized" do
      model = create(:analysable, title: "<h1>Header</h1><!-- msg -->",
                     content: "\nThis is a new\tbit of content")
      expect(model.keywords.pluck(:name)).to eq(%w(header this is a new bit of content))
    end

    it "suggests stopwords" do
      10.times do |n|
        create(:analysable, title: "a"*n, content: "duped")
      end
      expect(RailsNlp.suggest_stopwords(n: 1)).to include("duped")
    end

    it "stopwords are returned when amount requested is too large" do
      create(:analysable)
      expect(RailsNlp.suggest_stopwords(n: 100)).to_not be_nil
    end

  end
end
