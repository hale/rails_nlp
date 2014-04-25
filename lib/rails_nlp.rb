require 'rails_nlp/version'
require 'rails_nlp/configuration'
require 'rails_nlp/text_analyser'
require 'rails_nlp/keyword'
require 'rails_nlp/wordcount'
require 'rails_nlp/spell_checker'
require 'rails_nlp/query'

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

  def metaphones
    keywords.pluck(:metaphone).uniq
  end

  def self.spell_checker
    @spell_checker ||= SpellChecker.new
  end

  def self.suggest_stopwords(n: stopwords_default, n_max: stopwords_max)
    whitelist = RailsNlp.configuration.stopwords_whitelist || []
    blacklist = RailsNlp.configuration.stopwords_blacklist || []
    limit = [n, n_max].min
    freq = Wordcount.group(:keyword_id).order('count_all DESC').limit(limit).count
    Keyword.where(id: freq.map(&:first)).pluck(:name) - blacklist + whitelist
  end

  def self.expand(str)
    Query.new(str)
  end

  private

  def self.stopwords_default
    (Keyword.count * 0.1).floor
  end

  def self.stopwords_max
    200
  end

end
