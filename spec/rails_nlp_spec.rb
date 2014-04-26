require 'spec_helper'

module RailsNlp
  describe RailsNlp do
    describe "#keywords" do
      it "gives a list of Keywords for this model" do
        model = create(:analysable, title: "the dog", content: "a ball")
        expect(model.keywords.pluck(:name)).to eq(%w(the dog a ball))
      end

      it "keywords for model are sanitized" do
        model = create(:analysable, title: "<h1>Header</h1><!-- msg -->",
                       content: "\nThis is a new\tbit of content")
        expect(model.keywords.pluck(:name)).to eq(%w(header this is a new bit of content))
      end
    end

    describe "self.suggest_stopwords" do
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

    describe "#stems " do
      it "gives an array" do
        model = create(:analysable)
        expect(model.stems.class).to eq(Array)
      end

      it "size of array is equal to number of unique keywords in the model" do
        model = create(:analysable, title: "one two three", content: "four five six")
        expect(model.stems.size).to eq(6)
      end

      it "does not contain duplicates" do
        model = create(:analysable, title: "run running", content: "")
        expect(model.stems.size).to eq(1)
      end

      it "joins stems from each keyword in the model" do
        model = create(:analysable, title: "flippers digging", content: "")
        expect(model.stems).to eq(["flipper", "dig"])
      end
    end

    describe "#metaphones " do
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

    it "self.expand(str) gives a Query object" do
      expect(RailsNlp.expand("").class).to eq(Query)
    end

    it "#text_analyser gives a TextAnalyser object" do
      model = create(:analysable)
      expect(model.rails_nlp_text_analyser.class).to eq(TextAnalyser)
    end

    describe "analysed model is updated" do
      context "an existing word occurs less than before" do
        it "reduces Wordcount count" do
          m = create(:analysable, title: "dog bone", content: "the dog")
          dog_kw = Keyword.find_by(name: "dog")
          expect {
            m.update(title: "the bone")
          }.to change {
            Wordcount.find_by(keyword_id: dog_kw.id, analysable_id: m.id).count
          }.from(2).to(1)
        end
      end

      context "existing word occurs more than before" do
        it "increases wordcount count for that model" do
          m = create(:analysable, title: "dog bone", content: "the dog")
          dog_kw = Keyword.find_by(name: "dog")
          expect {
            m.update(title: "dog bone dog")
          }.to change {
            Wordcount.find_by(keyword_id: dog_kw.id, analysable_id: m.id).count
          }.from(2).to(3)
        end
      end

      context "word no longer occurs, but still exists in other models" do
        before(:each) do
          @model_1 = create(:analysable, title: "stick")
          @model_2 = create(:analysable, content: "stick")
          @model_1.update_attribute(:title, "foobar")
        end

        it "model#keywords no longer contains the keyword" do
          expect(@model_1.keywords.pluck(:name)).to_not include("stick")
        end

        it "other model's keywords still includes the word" do
          expect(@model_2.keywords.pluck(:name)).to include("stick")
        end
      end

      context "word no longer occurs, and is not present in any other record" do
        it "removed the keyword from the database" do
          model_1 = create(:analysable, content: "dog cat sheep")
          create(:analysable, content: "dog cat")
          model_1.update_attribute(:content, "dog bark")
          expect(Keyword.find_by(name: "sheep")).to be_nil
        end
      end

      context "a new word is introduced, not in any other record" do
        it "model#keywords contains the word" do
          m = create(:analysable, content: "walk in the park")
          m.update(title: "pumpkin juice")
          expect(m.keywords).to include(*Keyword.where(name: ["pumpkin", "juice"]))
        end
      end

      context "a new word is added to the model, already exists in other records" do
        it "model#keywords contains the word" do
          create(:analysable, title: "one two")
          m = create(:analysable)
          m.update(title: "two three")
          expect(m.keywords).to include(Keyword.find_by(name: "two"))
        end
      end

      context "changes are not made to the analysed fields" do
        it "does nothing" do
          m = create(:analysable, title: "the man and his dog")
          flexmock(RailsNlp.configuration).should_receive(:fields).and_return([])
          flexmock(m.rails_nlp_text_analyser).should_receive(:update).never
          m.update_attribute(:title, "the dog and his parrot")
        end
      end
    end

    describe "analysed model is deleted" do
      it "removes all wordcounts associated with the model" do
        m = create(:analysable, title: "the blue sandwich", content: "")
        expect { m.destroy }.to change { Wordcount.count }.by(-3)
      end

      it "removes any keywords not in any other models" do
        m = create(:analysable, title: "the blue sandwich", content: "")
        m.destroy
        expect(Keyword.find_by(name: "sandwich")).to be_nil
      end
    end

  end
end
