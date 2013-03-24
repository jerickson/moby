module Api
  module V1
    class ChaptersController < ApplicationController

      before_filter :find_chapter, :only => [:show]

      respond_to :json

      def index
        respond_with Chapter.all
      end

      def show
        respond_with @chapter
      end

      def create
        chapter = Chapter.create(params[:chapter])
        if chapter.valid?
          respond_with(chapter, :location => api_v1_chapter_path(chapter))
        else
          respond_with(chapter)
        end
      end

    private

      def find_chapter
        @chapter = Chapter.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          error = { :error => "The chapter you were looking for" +
                            " could not be found."}
          respond_with(error, :status => 404)
      end
      
    end
  end
end