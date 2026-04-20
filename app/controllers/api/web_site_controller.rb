module Api
  class WebSiteController < ApplicationController
    skip_before_action :authorize_request

    def get_page
      if params[:page].present?
        sections = Section.where(page: params[:page]).order(:position)
        if params[:page] == "home"
          brand = Brand.where(is_published: true).all
          render json: {brands: serialize_brands(brand), sections: serialize_sections(sections)}
        elsif params[:page] == "brands"
          brand = Brand.where(is_published: true).all
          render json: {brands: serialize_brands(brand), sections: serialize_sections(sections)}
        elsif params[:page] == "blogs"
          blogs = Blog.where(is_published: true).all
          render json: {blogs: serialize_blogs(blogs), sections: serialize_sections(sections)}
        else
          render json: serialize_sections(sections)
        end
      else
        render json: { errors: "Page not found" }, status: :not_found
      end
    end
    def get_all_blogs
      blogs = Blog.where(is_published: true).all
      render json: serialize_blogs(blogs)
    end
    def show_blog
      blog = Blog.find(params[:id])
      render json: serialize_blog(blog)
    end
    def show_brand_products
      brand = Brand.find(params[:id])
      products = Product.where(brand_id: brand.id, is_published: true).all
      render json: {brand: serialize_brand(brand), products: serialize_products(products)}
    end
    def get_all_faqs
      faqs = Faq.where(is_published: true).all
      render json: serialize_faqs(faqs)
    end
    def show_faq
      faq = Faq.find(params[:id])
      render json: serialize_faq(faq)
    end

    private
    def serialize_faqs(faqs)
      faqs.map { |f| serialize_faq(f) }
    end
    def serialize_faq(faq)
      {
        id: faq.id,
        question_ar: faq.question_ar,
        question_en: faq.question_en,
        answer_ar: faq.answer_ar,
        answer_en: faq.answer_en,
        is_published: faq.is_published
      }
    end
    def serialize_products(products)
      products.map { |p| serialize_product(p) }
    end
    def serialize_product(product)
      {
        id: product.id,
        title_ar: product.title_ar,
        title_en: product.title_en,
        alt_text_ar: product.alt_text_ar,
        alt_text_en: product.alt_text_en,
        image_url: product.cached_image_url,
        is_published: product.is_published,
        brand_id: product.brand_id,
        brand: product.brand,
        faqs: product.faqs
      }
    end
    def serialize_brands(brands)
      brands.map { |b| serialize_brand(b) }
    end
    def serialize_brand(brand)
      {
        id: brand.id,
        title_ar: brand.title_ar,
        title_en: brand.title_en,
        alt_text_ar: brand.alt_text_ar,
        alt_text_en: brand.alt_text_en,
        image_url: brand.cached_image_url,
        is_published: brand.is_published,
        products: brand.try(:products).map { |p| { id: p.id, title_ar: p.title_ar, title_en: p.title_en } }
      }
    end
    def serialize_blogs(blogs)
      blogs.map { |b| serialize_blog(b) }
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
        photo: blog.cached_image_url,
        contents: blog.blog_contents.map { |c| { id: c.id, content_ar: c.content_ar, content_en: c.content_en, photos: c.blog_con_photos.map {|cp| {url: cp.cached_photo_url, alt_ar: cp.alt_ar, alt_en: cp.alt_en} } } }
      }
    end
    def serialize_sections(sections)
      sections.map { |s| serialize_section(s) }
    end

    def serialize_section(section)
      section_type = section.section_type.to_s
      {
        section_type => {
          id:           section.id,
          page:         section.page.to_s,
          section_type: section_type,
          position:     section.position,
          settings:     section.settings,
          image_url:    section.image.attached? ? section.cached_image_url : nil,
          created_at:   section.created_at,
          updated_at:   section.updated_at
        }.merge(serialize_contents(section.contents))
      }
    end

    def serialize_contents(contents)
      contents.each_with_object({}) do |c, hash|
        hash[c.key] = {
          id:           c.id,
          value_ar:     c.value_ar,
          value_en:     c.value_en,
          content_type: c.content_type,
          position:     c.position
        }
      end
    end
  end
end