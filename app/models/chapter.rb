class Chapter < ActiveRecord::Base
  attr_accessible :book, :book_id, :name, :position

  validates :book, :name, :position, :presence => true
  validates :name, :position, :uniqueness => { :scope => :book_id }

  belongs_to :book
  has_many :paragraphs

end
