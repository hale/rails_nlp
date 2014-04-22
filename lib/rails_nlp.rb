require 'rails_nlp/version'
require 'rails_nlp/configuration'
require 'rails_nlp/text_analyser'
require 'rails_nlp/keyword'
require 'rails_nlp/wordcount'
require 'rails_nlp/spell_checker'

require 'active_support/concern'

module RailsNlp
  extend ActiveSupport::Concern

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  included do
    has_many :wordcounts, class_name: RailsNlp::Wordcount, foreign_key: "analysable_id"
    has_many :keywords, through: :wordcounts, class_name: RailsNlp::Keyword

    after_save :analyse_model
  end

  def analyse_model
    rails_nlp_text_analyser.analyse
  end

  def rails_nlp_text_analyser
    @text_analyser ||= TextAnalyser.new(model: self, fields: RailsNlp.configuration.fields)
  end

  def self.spell_checker
    @spell_checker ||= SpellChecker.new
  end

  def self.suggest_stopwords(n: nil)
    if RailsNlp.configuration.respond_to?(:stopwords_whitelist)
      whitelist = RailsNlp.configuration.stopwords_whitelist
    else
      whitelist = []
    end
    if RailsNlp.configuration.respond_to?(:stopwords_blacklist)
      blacklist = RailsNlp.configuration.stopwords_blacklist
    else
      blacklist = []
    end
    n ||= (Keyword.count * 0.1).ceil
    freq = Wordcount.group(:keyword_id).order('count_all DESC').limit(n).count
    Keyword.where(id: freq.map(&:first)).pluck(:name) - blacklist + whitelist
  end

end
