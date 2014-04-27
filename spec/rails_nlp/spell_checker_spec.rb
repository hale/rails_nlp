require 'spec_helper'

module RailsNlp
  describe SpellChecker do

    let(:spell_checker) { RailsNlp.spell_checker }

    it "can identify correctly spelled words" do
      expect(spell_checker.correct?("sugar")).to eq(true)
    end

    it "can identify incorrectly spelled words" do
      expect(spell_checker.correct?("sugrar")).to eq(false)
    end

    describe "suggest" do
      it "suggestions come from existing keywords" do
        FactoryGirl.create(:analysable, title: "three", content: "")
        expect(spell_checker.suggest("thre")).to eq("three")
      end

      it "returns the word when it is correct English and not in database" do
        expect(spell_checker.suggest("cow")).to eq("cow")
      end

      it "gives the word when no suggestions are present" do
        expect(spell_checker.suggest("nonsenseword")).to eq("nonsenseword")
      end
    end
  end
end
