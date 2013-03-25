require 'spec_helper'

describe Api::V1::ChaptersController do

  describe "GET on /api/v1/chapters" do

    before(:each) do
     @chapter = FactoryGirl.create(:chapter)
    end

    let(:url) {"/api/v1/chapters"}

    it "should return the list of all chapters" do
      get "#{url}"
      response.should be_success
      json = JSON.parse(response.body)
      json.count.should eq(1)
    end

    it "should return the correct chapters" do
      get "#{url}"
      response.should be_success
      response.body.should eql([@chapter].to_json)
    end

  end

  describe "GET on /api/v1/chapters/:id" do

    before(:each) do
      @chapter = FactoryGirl.create(:chapter)
    end

    let(:url) {"/api/v1/chapters/#{@chapter.id}"}

    it "should return the correct chapter" do
      get "#{url}"
      response.should be_success
      response.body.should eql(@chapter.to_json)
    end

    it "should return chapter not found" do
      get "#{url}1-2-3-4"
      response.status.should eq(404)
    end

  end

  describe "POST on /api/v1/chapters" do

    before(:each) do
      @book = FactoryGirl.create(:book)
    end

    let(:url) {"/api/v1/chapters"}

    it "should create a chapter" do
      post "#{url}.json", :chapter => {
                  :book_id => @book.id,
                  :name => "Chapter 1. Loomings",
                  :position => "1"}

      chapter = @book.chapters.find_by_name("Chapter 1. Loomings")
      route = "#{url}/#{chapter.id}"

      response.status.should eq(201)
      response.headers["Location"].should eql(route)
      response.body.should eql(chapter.to_json)
    end

    it "should fail when chapter is invalid" do
      post "#{url}.json", :chapter => {
                  :book_id => @book.id,
                  :name => "Chapter 1. Loomings"}

      error = { :errors => { :position => ["can't be blank"] }}
      response.body.should eql(error.to_json)
      response.status.should eql(422)
    end

  end
  
end
