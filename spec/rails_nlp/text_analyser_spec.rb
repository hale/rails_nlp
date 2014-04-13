require 'spec_helper'

module RailsNlp
  describe TextAnalyser do
    it "fetches the fields from the config" do
      flexmock(Configurator).should_receive(:fields).once.and_return(["tst"])
      TextAnalyser.analyse(analysable: flexmock("analysable AR model"))
    end
  end
end
