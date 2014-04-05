require 'active_record'

class Wordcount < ActiveRecord::Base

  belongs_to :record
  belongs_to :keyword

  # FIXME: should be default 0 in the migration, not done through ruby.
  before_validation :set_count_if_nil

  private

  def set_count_if_nil
    self.count = 0 if self.count.nil?
  end

  private

  def keyword_parans
    params.require(:wordcount).permit(:record_id, :count, :keyword_id)
  end

end
