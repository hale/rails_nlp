require 'ffi/hunspell'

module RailsNlp
  class SpellChecker

    DICT_EN = File.expand_path("../../../assets/dict-en/", __FILE__)

    def initialize
      FFI::Hunspell.directories.unshift(DICT_EN)
      @dict = FFI::Hunspell.dict("en_US")
    end

    def correct?(word)
      @dict.check? word
    end
  end
end
