module Api
  class BlogsController < ApplicationController
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
        render json: serialize_blog(@blog), status: :created
      else
        render json: { errors: @blog.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      if @blog.update(blog_params)
        render json: serialize_blog(@blog)
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
        blog_photos_attributes: [:id, :photo, :alt_ar, :alt_en, :is_arabic, :_destroy],
        contents_attributes: [
          :id, :key, :value, :content_type, :position, :_destroy,
          content_photos_attributes: [:id, :photo, :alt_ar, :alt_en, :_destroy]
        ]
      )
    end

    def serialize_blogs(blogs)
      blogs.includes(:blog_photos, :contents, :faqs).map { |b| serialize_blog(b) }
    end

    def serialize_blog(blog)
      {
        id: blog.id,
        title_ar: blog.title_ar,
        title_en: blog.title_en,
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
        photos: blog.blog_photos.map { |p| { id: p.id, alt_ar: p.alt_ar, alt_en: p.alt_en, photo_url: p.cached_photo_url } },
        contents: blog.contents.map { |c| { id: c.id, key: c.key, value: c.value, photos: c.content_photos.map {|cp| {url: cp.cached_photo_url, alt_ar: cp.alt_ar, alt_en: cp.alt_en} } } }
      }
    end
  end
end
