require 'spec_helper'

module RailsNlp
  describe Query do

    it "is instantiated with a string, the search query" do
      expect(Query.new("My search").to_s).to eq("My search")
    end

    it "#keywords gives the query sanitized, with stopwords removed" do
      flexmock(RailsNlp).should_receive(:suggest_stopwords).and_return(["penguin"])
      q = Query.new("a penguin is brown")
      expect(q.keywords).to eq("a is brown")
    end

    it "#metaphones gives the keywords converted to metaphones" do
      q = Query.new("badger hole")
      expect(q.metaphones).to eq("PJR HL")
    end

    it "#stems gives the stems of the keywords" do
      q = Query.new("switching bars")
      expect(q.stems).to eq("switch bar")
    end

    describe "#correct?" do
      it "true when every word in query is correctly spelled English word" do
        q = Query.new("i can spell like a champion")
        expect(q.correct?).to eq(true)
      end

      it "false when any word is not English word" do
        q = Query.new("unfortunately mytyping is bad")
        expect(q.correct?).to eq(false)
      end
    end

    describe "#corrected" do
      it "only suggests words that are in the database" do
        FactoryGirl.create(:analysable, content: "How to clean the sticky keys your keyboard has")
        q = Query.new("My keyboardd haas stickyy keysy")
        expect(q.corrected).to eq("My keyboard has sticky keys")
      end

      it "does not try and correct English words that are not in the database" do
        q = Query.new("This is all correct")
        expect(q.corrected).to eq("This is all correct")
      end

    end
  end
end
