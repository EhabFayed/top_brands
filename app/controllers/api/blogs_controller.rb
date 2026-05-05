module Api
  class BlogsController < ApplicationController
    before_action :require_admin_or_manager!
    before_action :set_blog, only: [:show, :update, :destroy]

    def index
      @blogs = Blog.all
      render json: serialize_blogs(@blogs)
    end

    def show
      render json: serialize_blog(@blog)
    end

    def create
      @blog = Blog.new(blog_params)

      if @blog.save
        render json: { message: "Blog created successfully" }, status: :created
      else
        render json: { errors: @blog.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      if @blog.update(blog_params)
        render json: { message: "Blog updated successfully" }, status: :ok
      else
        render json: { errors: @blog.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      @blog.destroy!
      head :no_content
    end

    private

    def set_blog
      @blog = Blog.find(params[:id])
    end

    def blog_params
      params.require(:blog).permit(
        :title_ar, :title_en, :description_ar, :description_en,
        :meta_title_ar, :meta_title_en, :slug, :slug_ar,
        :meta_description_ar, :meta_description_en, :is_published, :category,
        :image, :alt_ar, :alt_en,
        contents_attributes: [
          :id, :key, :value, :content_type, :position, :_destroy,
          content_photos_attributes: [:id, :photo, :alt_ar, :alt_en, :_destroy]
        ]
      )
    end

    def serialize_blogs(blogs)
      blogs.includes(:blog_contents, :faqs).map { |b| serialize_blog(b) }
    end

    def serialize_blog(blog)
      {
        id: blog.id,
        title_ar: blog.title_ar,
        title_en: blog.title_en,
        alt_ar: blog.alt_ar,
        alt_en: blog.alt_en,
        slug: blog.slug,
        slug_ar: blog.slug_ar,
        description_ar: blog.description_ar,
        description_en: blog.description_en,
        meta_title_ar: blog.meta_title_ar,
        meta_title_en: blog.meta_title_en,
        meta_description_ar: blog.meta_description_ar,
        meta_description_en: blog.meta_description_en,
        is_published: blog.is_published,
        category: blog.category,
        image: blog.cached_image_url,
        contents: blog.blog_contents.map { |c| { id: c.id, content_ar: c.content_ar, content_en: c.content_en, photos: c.blog_con_photos.map {|cp| {url: cp.cached_photo_url, alt_ar: cp.alt_ar, alt_en: cp.alt_en} } } }
      }
    end
  end
end
