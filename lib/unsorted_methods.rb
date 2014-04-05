

  def related
    Rails.cache.fetch("#{self.id}-related") {
      return [] if wordcounts.empty?
      (Article.search(self.wordcounts.all(:order => 'count DESC', :limit => 10).map(&:keyword).map(&:name).join(" OR ")) - [self]).first(4)
    }
  end
