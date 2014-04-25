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

    describe "#suggest_stopwords" do
      it "gives most common words across all records" do
        create(:analysable, title: "one", content: "duped")
        create(:analysable, title: "two", content: "duped")
        expect(RailsNlp.suggest_stopwords(n: 1)).to eq(["duped"])
      end

      it "stopwords are returned when amount requested is too large" do
        create(:analysable)
        expect(RailsNlp.suggest_stopwords(n: 100)).to_not be_nil
      end

      it "always suggests whitelisted words" do
        flexmock(RailsNlp.configuration) do |m|
          m.should_receive(:stopwords_whitelist).and_return(["horse"]).once
        end
        expect(RailsNlp.suggest_stopwords).to include("horse")
      end

      it "never includes blacklisted words" do
        create(:analysable, title: "house", content: "house")
        flexmock(RailsNlp.configuration) do |m|
          m.should_receive(:stopwords_blacklist).and_return(["house"])
        end
        expect(RailsNlp.suggest_stopwords).to_not include("house")
      end

      it "whitelist takes priority over blacklist" do
        flexmock(RailsNlp.configuration) do |m|
          m.should_receive(:stopwords_whitelist).and_return(["house"])
          m.should_receive(:stopwords_blacklist).and_return(["house"])
        end
        expect(RailsNlp.suggest_stopwords).to include("house")
      end

      it "by default number of stopwords is 10% of Keyword.count" do
        model = create(:analysable)
        25.times do |n|
          model.keywords.create(name: "a"*n)
        end
        expect(RailsNlp.suggest_stopwords.size).to eq(2)
      end

      it "can set a max number of stopwords" do
        model = create(:analysable)
        20.times do |n|
          model.keywords.create(name: "a"*n)
        end
        expect(RailsNlp.suggest_stopwords(n_max: 1).size).to eq(1)
      end
    end

    describe "model#metaphones " do
      it "gives an array" do
        model = create(:analysable)
        expect(model.metaphones.class).to eq(Array)
      end

      it "size of array is equal to number of unique keywords in the model" do
        model = create(:analysable, title: "one two three", content: "four five six")
        expect(model.metaphones.size).to eq(6)
      end

      it "does not contain duplicates" do
        model = create(:analysable, title: "one won", content: "")
        expect(model.metaphones.size).to eq(1)
      end

      it "joins metaphones from each keyword in the model" do
        model = create(:analysable, title: "food basket", content: "")
        expect(model.metaphones).to eq(["FT", "PSKT"])
      end
    end

    it "#expand(str) gives a Query object" do
      expect(RailsNlp.expand("").class).to eq(Query)
    end

  end
end
