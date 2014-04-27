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

    def suggest(str)
      if correct?(str)
        str
      else
        dict_custom = FFI::Hunspell.dict("en_BLANK")
        populate(dict_custom)
        dict_custom.suggest(str).first || str
      end
    end

    private

    def populate(dict_custom)
      Keyword.pluck(:name).each { |kw| dict_custom.add(kw) }
    end
  end
end
