require 'spec_helper'

describe Api::V1::AuthorsController do

  describe "GET on /api/v1/authors" do

  	before(:each) do
      @author = FactoryGirl.create(:author)
  	end

  	it "should return the list of all authors" do
  	  get '/api/v1/authors'
  	  response.should be_success
  	  json = JSON.parse(response.body)
  	  json.count.should eq(1)
  	end

  	it "should return the correct authors" do
  	  get '/api/v1/authors'
  	  response.should be_success
  	  json = JSON.parse(response.body)
  	  json.first["first_name"].should eq("Herman")
  	  json.first["last_name"].should eq("Melville")
  	end

  end

  describe "GET on /api/v1/authors/:id" do

    before(:each) do
      @author = FactoryGirl.create(:author)
    end

    let(:url) {"/api/v1/authors/#{@author.id}"}

    it "should return the correct author" do
      get "#{url}"
      response.should be_success
      response.body.should eql(@author.to_json)
    end

    it "should return book not found" do
      get "#{url}1234"
      response.status.should eq(404)
    end

  end

  describe "POST on /api/v1/authors" do

  	let(:url) {"/api/v1/authors"}

  	it "should create an author" do
  	  post "#{url}.json", :author => {
  	  						:first_name => "James",
  	  						:last_name => "Joyce"}

  	  author = Author.find_by_first_name_and_last_name("James", "Joyce")
  	  route = "#{url}/#{author.id}"

      response.status.should eq(201)
      response.headers["Location"].should eql(route)
	    response.body.should eql(author.to_json)
  	end

    it "should fail when author is invalid" do
      post "#{url}.json", :author => {
                  :first_name => "James"}

      error = { :errors => { :last_name => ["can't be blank"] }}
      response.body.should eql(error.to_json)
      response.status.should eql(422)
    end

  end
  
end