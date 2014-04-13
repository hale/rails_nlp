module RailsNlp
  class Wordcount < ActiveRecord::Base

    belongs_to :association
    belongs_to :keyword

    # FIXME: should be default 0 in the migration, not done through ruby.
    before_validation :set_count_if_nil

    private

    def set_count_if_nil
      self.count = 0 if self.count.nil?
    end

    def keyword_params
      params.require(:wordcount).permit(:association_id, :count, :keyword_id)
    end

  end
end
