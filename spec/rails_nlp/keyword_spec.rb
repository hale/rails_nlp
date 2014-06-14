require 'spec_helper'

module RailsNlp
  describe Keyword do
    it { is_expected.to validate_presence_of(:name)}
    it { is_expected.to validate_uniqueness_of(:name)}
    it { is_expected.to have_many(:wordcounts) }

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

