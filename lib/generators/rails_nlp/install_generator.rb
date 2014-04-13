module RailsNlp
  module Generators
    class InstallGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("../templates", __FILE__)

      desc 'Create migration templates for Wordcount and Keyword models'

      def create_migrations
        now = Time.now.utc
        filename = "#{now.strftime('%Y%m%d%H%M%S')}_create_rails_nlp_keywords_and_wordcounts.rb"
        template "create_rails_nlp_keywords_and_wordcounts.rb.erb", "db/migrate/#{filename}"
      end

      private

      alias_method :association, :file_name

    end
  end
end
