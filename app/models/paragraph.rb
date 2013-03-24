class Paragraph < ActiveRecord::Base
  attr_accessible :position, :text

  belongs_to :chapter
  
  validates_uniqueness_of :position, :scope => :chapter_id
end
