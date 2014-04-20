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

  def self.suggest_stopwords(n: 10)
    kws = Book.all.map(&:keywords)
    dkw = kws.map{ |kww| kww.map(&:name) }
    fdkw = dkw.flatten
    freq = fdkw.each_with_object(Hash.new(0)) { |wrd,cnt| cnt[wrd] +=1 }
    freq.sort_by { |_,count| count }[-n,n].map(&:first)
  end

end
