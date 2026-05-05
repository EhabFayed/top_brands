module Api
  class WebSiteController < ApplicationController
    skip_before_action :authorize_request

    def get_page
      if params[:page].present?
        sections = Section.where(page: params[:page]).order(:position)
        if params[:page] == "home"
          # Home: highlighted brands are a curated short list — no pagination needed
          brand = Brand.where(is_published: true, is_highlighted: true).all
          render json: filter_by_locale({ brands: serialize_brands(brand), sections: serialize_sections(sections) })
        elsif params[:page] == "brands"
          pagy, brands = pagy(Brand.where(is_published: true), limit: params.fetch(:items, 20).to_i)
          render json: filter_by_locale({
            pagination: pagination_metadata(pagy),
            brands:     serialize_brands(brands),
            sections:   serialize_sections(sections)
          })
        elsif params[:page] == "blogs"
          pagy, blogs = pagy(Blog.where(is_published: true), limit: params.fetch(:items, 20).to_i)
          render json: filter_by_locale({
            pagination: pagination_metadata(pagy),
            blogs:      serialize_blogs(blogs),
            sections:   serialize_sections(sections)
          })
        else
          render json: filter_by_locale(serialize_sections(sections))
        end
      else
        render json: { errors: "Page not found" }, status: :not_found
      end
    end

    def get_all_blogs
      pagy, blogs = pagy(Blog.where(is_published: true), limit: params.fetch(:items, 20).to_i)
      render json: filter_by_locale({
        pagination: pagination_metadata(pagy),
        data:       serialize_blogs(blogs)
      })
    end

    def show_blog
      blog = Blog.find(params[:id])
      render json: filter_by_locale(serialize_blog(blog))
    end

    def show_brand_products
      brand    = Brand.find(params[:id])
      pagy, products = pagy(Product.where(brand_id: brand.id, is_published: true), limit: params.fetch(:items, 20).to_i)
      render json: filter_by_locale({
        brand:      serialize_brand(brand),
        pagination: pagination_metadata(pagy),
        products:   serialize_products(products)
      })
    end

    def get_all_faqs
      pagy, faqs = pagy(Faq.where(is_published: true), limit: params.fetch(:items, 20).to_i)
      render json: filter_by_locale({
        pagination: pagination_metadata(pagy),
        data:       serialize_faqs(faqs)
      })
    end

    def show_faq
      faq = Faq.find(params[:id])
      render json: filter_by_locale(serialize_faq(faq))
    end

    def get_company_data
      company_data = CompanyDatum.first
      render json: filter_by_locale(serialize_company_data(company_data))
    end

    private
    def serialize_company_data(company_data)
      {
        id: company_data.id,
        address_ar: company_data.address_ar,
        address_en: company_data.address_en,
        phone_number_1: company_data.phone_number_1,
        phone_number_2: company_data.phone_number_2,
        whatsapp_number: company_data.whatsapp_number,
        email: company_data.email,
        google_maps_url: company_data.google_maps_url,
        working_hours_ar: company_data.working_hours_ar,
        working_hours_en: company_data.working_hours_en,
        facebook_url: company_data.facebook_url,
        instagram_url: company_data.instagram_url,
        twitter_url: company_data.twitter_url,
        linkedin_url: company_data.linkedin_url
      }
    end

    def filter_by_locale(data)
      locale = request.headers['locale']
      return data unless %w[ar en].include?(locale)

      if data.is_a?(Hash)
        filtered_hash = {}
        data.each do |key, value|
          key_str = key.to_s
          if key_str.end_with?("_ar", "_en")
            if key_str.end_with?("_#{locale}")
              filtered_hash[key_str.sub("_#{locale}", "").to_sym] = filter_by_locale(value)
            end
          else
            filtered_hash[key] = filter_by_locale(value)
          end
        end
        filtered_hash
      elsif data.is_a?(Array)
        data.map { |item| filter_by_locale(item) }
      else
        data
      end
    end
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
        faqs: product.faqs,
        size: product.size
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
        description_ar: brand.description_ar,
        description_en: brand.description_en,
        meta_title_ar: brand.meta_title_ar,
        meta_title_en: brand.meta_title_en,
        meta_description_ar: brand.meta_description_ar,
        meta_description_en: brand.meta_description_en,
        is_published: brand.is_published,
        products: brand.try(:products).map { |p| { id: p.id, title_ar: p.title_ar, title_en: p.title_en,image_url: p.cached_image_url,size: p.size } }
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