module Api
  class EnumsController < ApplicationController
    # GET /api/enums
    def index
      render json: {
        blog_categories: Blog::CATEGORIES.keys.map(&:to_s),
        pages:         Section::PAGES.keys.map(&:to_s),
        section_types: Section::SECTION_TYPES.keys.map(&:to_s),
      }
    end
    def get_all_counts
      render json: {
        blogs_count: Blog.count,
        products_count: Product.count,
        brands_count: Brand.count,
        faqs_count: Faq.count,
        company_data_count: CompanyDatum.first.attributes.values.compact.count
      }
    end
  end
end
