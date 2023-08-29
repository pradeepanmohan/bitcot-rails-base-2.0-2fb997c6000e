class Post < ApplicationRecord
  audited
  has_paper_trail
  searchkick text_middle: %i[title content]

  belongs_to :user

  validates_length_of :title, maximum: 64, minimum: 2
  validates_length_of :content, maximum: 1000, minimum: 10

  enum active_status: [:active, :inactive, :deleted]

  # def self.search(params)
  #   params[:query].blank? ? all : where(
  #     "title LIKE ?", "%#{sanitize_sql_like(params[:query])}%"
  #   )
  # end

end