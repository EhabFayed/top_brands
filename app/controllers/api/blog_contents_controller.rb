module Api
  class BlogContentsController < ApplicationController
    before_action :set_blog_content, only: [:show, :update, :destroy]

    def index
      @blog_contents = BlogContent.all
      render json: @blog_contents
    end

    def show
      render json: @blog_content
    end

    def create
      @blog_content = BlogContent.new(blog_content_params)

      if @blog_content.save
        render json: { message: "Blog content created successfully" }, status: :created
      else
        render json: { errors: @blog_content.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      if @blog_content.update(blog_content_params)
        render json: { message: "Blog content updated successfully" }, status: :ok
      else
        render json: { errors: @blog_content.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      @blog_content.destroy!
      render json: { message: "Blog content deleted successfully" }, status: :ok
    end

    private

    def set_blog_content
      @blog_content = BlogContent.find(params[:id])
    end

    def blog_content_params
      params.require(:blog_content).permit(:blog_id, :content_ar, :content_en, blog_con_photos_attributes: [:id, :alt_ar, :alt_en, :photo, :_destroy])
    end
  end
end