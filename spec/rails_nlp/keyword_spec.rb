require 'spec_helper'

module RailsNlp
  describe Keyword do
    #before(:each) do
      #@model = flexmock("analysable model")
      #@model.should_receive(:id).and_return(1)
      #@model.should_receive(:title).and_return("Title").by_default
      #@model.should_receive(:content).and_return("Content").by_default
      #@thesaurus = Bronto::Thesaurus.new
      #end
    
    it { should validate_presence_of(:name)}
    it { should validate_uniqueness_of(:name)}
    it { should have_many(:wordcounts) }

    describe "analysis of keywords before save" do
      describe "phonetic" do
        it "changes the metaphone field" do
          kw = Keyword.create(name: "food")
          expect(kw.metaphone).to_not be_nil
        end

        it "calculates the metaphone phonetic approximation of the keyword" do
          kw = Keyword.create(name: "vegetable")
          expect(kw.metaphone).to eq("FKTP")
        end
      end

      describe "stemming" do
        it "changes the #stem field" do
          kw = Keyword.create(name: "flailing")
          expect(kw.stem).to eq("flail")
        end
      end

      describe "synonym generation" do

        it "changes the #synonyms field" do
          kw = Keyword.create(name: "fish")
          expect(kw.synonyms.class).to eq(Array)
        end

        it "sets the #synonyms to be an array of synonyms" do
          thesaurus = Bronto::Thesaurus.new
          flexmock(thesaurus).should_receive(:lookup).with("cat").and_return({
            noun: { syn: ["adult female", "adult male"]},
            verb: { syn: ["barf", "cast", "chuck"]}
          })
          kw = Keyword.create(name: "cat")
          expect(kw.synonyms).to eq(%w(adult\ female adult\ male barf cast chuck))
        end
      end
    end

    describe "orphans scope" do
      it "gives keywords not associated with any model" do
        kw = Keyword.create(name: "testbed")
        Wordcount.create(analysable_id: 1, keyword_id: kw.id, count: 1)
        orphan = Keyword.create(name: "oliver")

        expect(Keyword.orphans).to eq([orphan])
      end
    end


  end
end

