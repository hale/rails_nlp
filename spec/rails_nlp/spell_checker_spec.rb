require 'spec_helper'

module RailsNlp
  describe SpellChecker do
    it "can identify correctly spelled words" do
      expect(RailsNlp.spell_checker.correct?("sugar")).to eq(true)
    end

    it "can identify incorrectly spelled words" do
      expect(RailsNlp.spell_checker.correct?("sugrar")).to eq(false)
    end
  end
end
