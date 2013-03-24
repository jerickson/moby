module Api
  module V1
    class BooksController < ApplicationController
      
      before_filter :find_book, :only => [:show]

      respond_to :json

      def index
        respond_with Book.all
      end

      def show
        respond_with @book
      end

      def create
        book = Book.create(params[:book])
        if book.valid?
          respond_with(book, :location => api_v1_book_path(book))
        else
          respond_with(book)
        end
      end
      
    private
    
      def find_book
        @book = Book.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          error = { :error => "The book you were looking for" +
                            " could not be found."}
          respond_with(error, :status => 404)
      end

    end
  end
end