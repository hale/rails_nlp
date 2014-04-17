require 'spec_helper'

module RailsNlp
  describe Keyword do
    it { should validate_presence_of(:name)}
    it { should validate_uniqueness_of(:name)}
  end
end

