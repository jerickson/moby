class Book < ActiveRecord::Base
  attr_accessible :author, :author_id, :isbn13, :title

  belongs_to :author
  has_many :chapters

  validates :author, :title, :presence => true
end
