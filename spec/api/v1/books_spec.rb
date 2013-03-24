require 'spec_helper'

describe Api::V1::BooksController do

  describe "GET on /api/v1/books" do

    before(:each) do
	   @book = FactoryGirl.create(:book)
  	end

    let(:url) {"/api/v1/books"}

  	it "should return the list of all books" do
  	  get "#{url}"
  	  response.should be_success
  	  json = JSON.parse(response.body)
  	  json.count.should eq(1)
  	end

  	it "should return the correct book" do
  	  get "#{url}"
  	  response.should be_success
  	  response.body.should eql([@book].to_json)
  	end

  end

  describe "GET on /api/v1/books/:id" do

    before(:each) do
      @book = FactoryGirl.create(:book)
    end

    let(:url) {"/api/v1/books/#{@book.id}"}

    it "should return the correct books" do
      get "#{url}"
      response.should be_success
      response.body.should eql(@book.to_json)
    end

    it "should return book not found" do
      get "#{url}1234"
      response.status.should eq(404)
    end

  end

  describe "POST on /api/v1/books" do

    before(:each) do
      @author = FactoryGirl.create(:author)
    end

  	let(:url) {"/api/v1/books"}

  	it "should create an book" do
  	  post "#{url}.json", :book => {
                  :author_id => @author.id,
  	  						:title => "Billy Budd",
  	  						:isbn13 => "999999999999"}

  	  book = Book.find_by_title("Billy Budd")
  	  route = "#{url}/#{book.id}"

      response.status.should eq(201)
      response.headers["Location"].should eql(route)
	    response.body.should eql(book.to_json)
  	end

    it "should fail when book is invalid" do
      post "#{url}.json", :book => {
                  :title => "Billy Budd"}

      error = { :errors => { :author => ["can't be blank"] }}
      response.body.should eql(error.to_json)
      response.status.should eql(422)
    end

  end
  
end