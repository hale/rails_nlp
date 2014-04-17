require 'rails_nlp/version'
require 'rails_nlp/configuration'
require 'rails_nlp/text_analyser'
require 'rails_nlp/keyword'
require 'rails_nlp/wordcount'

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
    has_many :wordcounts, class: RailsNlp::Wordcount
    has_many :keywords, through: :wordcounts, class: RailsNlp::Keyword

    after_save :analyse_model
  end

  def analyse_model
    TextAnalyser.analyse(self)
  end


end
