require 'spec_helper'

describe Book do
  
  it "should require an author" do
    Book.create(:title => "Moby Dick").should have(1).error_on(:author)
  end

  it "should require a title" do
    author = FactoryGirl.create(:author)
    Book.create(:author => author).should have(1).error_on(:title)
  end

end
