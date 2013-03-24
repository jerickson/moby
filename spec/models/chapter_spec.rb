require 'spec_helper'

describe Chapter do
  
  before(:each) do
  	@book = FactoryGirl.create(:book)
  end

  it "should require a book" do
    Chapter.create(:name => "Chapter 1", :position => 1).should have(1).error_on(:book)
  end

  it "should require a name" do
  	@book.chapters.create(:position => 1).should have(1).error_on(:name)
  end

  it "should require a position" do
  	@book.chapters.create(:name => "Chapter 1").should have(1).error_on(:position)
  end

  it "should not allow duplicate names in a book" do
    @book.chapters.create(:name => "Chapter 1", :position => 1)
    @book.chapters.create(:name => "Chapter 1", :position => 2).should have(1).error_on(:name)
  end

  it "should not allow duplicate positions within a book" do
    @book.chapters.create(:name => "Chapter 1", :position => 1)
    @book.chapters.create(:name => "Chapter 2", :position => 1).should have(1).error_on(:position)
  end

end