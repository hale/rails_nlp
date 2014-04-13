module RailsNlp
  module Generators
    class InstallGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("../templates", __FILE__)

      argument :fields, type: :array, default: [], banner: "field [field] [field] ..."

      desc 'Create migration templates for Wordcount and Keyword models. ' +
        'Creates an initializer'

      def setup
        now = Time.now.utc
        filename = "#{now.strftime('%Y%m%d%H%M%S')}_create_rails_nlp_keywords_and_wordcounts.rb"
        template "create_rails_nlp_keywords_and_wordcounts.rb.erb", "db/migrate/#{filename}"
        template "rails_nlp.rb.erb", "config/initializers/rails_nlp.rb"
      end

      private

      alias_method :analysable, :file_name

    end
  end
end
