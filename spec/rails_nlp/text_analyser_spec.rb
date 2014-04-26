require 'spec_helper'

module RailsNlp
  describe TextAnalyser do
    describe "CREATE" do
      before(:each) do
        @model = flexmock("analysable model")
        @model.should_receive(:id).and_return(1)
        @model.should_receive(:title).and_return("Title").by_default
        @model.should_receive(:content).and_return("Content").by_default
      end

      it "creates a keyword record" do
        text_analyser = TextAnalyser.new(model: @model, fields: [:title])
        expect{text_analyser.analyse}.to change{Keyword.count}
      end

      it "creates one keyword per unique word" do
        @model.should_receive(:content).and_return("echo echo falls")
        TextAnalyser.new(model: @model, fields: [:content]).analyse
        expect(Keyword.count).to eq(2)
      end

      it "is case insensitive" do
        @model.should_receive(:content).and_return("Happy happy")
        TextAnalyser.new(model: @model, fields: [:content]).analyse
        expect(Keyword.pluck(:name)).to eq(["happy"])
      end

      it "skips a field if there is no content" do
        @model.should_receive(:title).and_return(nil)
        @model.should_receive(:content).and_return("hullabaloo")
        TextAnalyser.new(model: @model, fields: [:title, :content]).analyse
        expect(Keyword.count).to eq(1)
      end

      it "treats a tab as a separator" do
        @model.should_receive(:content).and_return("tab\tdelimited\tstuff")
        TextAnalyser.new(model: @model, fields: [:content]).analyse
        expect(Keyword.pluck(:name)).to eq(%w(tab delimited stuff))
      end

      it "handles HTML" do
        @model.should_receive(:content).and_return("<p>included</p><!-- excluded -->")
        TextAnalyser.new(model: @model, fields: [:content]).analyse
        expect(Keyword.pluck(:name)).to eq(["included"])
      end

      it "doesn't store words that are incorrectly spelled" do
        @model.should_receive(:content).and_return("qweqweqwe")
        TextAnalyser.new(model: @model, fields: [:content]).analyse
        expect(Keyword.count).to eq(0)
      end

      it "doesn't store words containing punctuation" do
        @model.should_receive(:content).and_return("\"Wow!\" shouted the man")
        TextAnalyser.new(model: @model, fields: [:content]).analyse
        expect(Keyword.pluck(:name)).to eq(%w(shouted the man))
      end
    end

  end
end
