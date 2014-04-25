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
  end
end
