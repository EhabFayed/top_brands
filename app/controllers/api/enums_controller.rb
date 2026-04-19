module Api
  class EnumsController < ApplicationController
    # GET /api/enums
    def index
      render json: {
        blog_categories: Blog::CATEGORIES.keys.map(&:to_s),
        pages:         Section::PAGES.keys.map(&:to_s),
        section_types: Section::SECTION_TYPES.keys.map(&:to_s),
        blogs_count: Blog.count,
        products_count: Product.count,
        brands_count: Brand.count,
        faqs_count: Faq.count,
        leaderships_count: Leadership.count,
        company_data_count: CompanyDatum.first.attributes.values.compact.count
      }
    end
  end
end
