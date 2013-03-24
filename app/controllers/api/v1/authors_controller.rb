module Api
  module V1
    class AuthorsController < ApplicationController
      
      before_filter :find_author, :only => [:show]

      respond_to :json

      def index
        respond_with Author.all
      end

      def show
        respond_with @author
      end

      def create
        author = Author.create(params[:author])
        if author.valid?
          respond_with(author, :location => api_v1_author_path(author))
        else
          respond_with(author)
        end
      end

    private

      def find_author
        @author = Author.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          error = { :error => "The author you were looking for" +
                            " could not be found."}
          respond_with(error, :status => 404)
      end
      
    end
  end
end