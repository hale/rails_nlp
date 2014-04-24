require 'spec_helper'

module RailsNlp
  describe Keyword do
    it { should validate_presence_of(:name)}
    it { should validate_uniqueness_of(:name)}

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


  end
end

