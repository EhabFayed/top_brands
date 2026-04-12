module Api
  class EnumsController < ApplicationController
    # GET /api/enums
    def index
      render json: {
        blog_categories: Blog::CATEGORIES.keys.map(&:to_s),
        pages:         Section::PAGES.keys.map(&:to_s),
        section_types: Section::SECTION_TYPES.keys.map(&:to_s)
      }
    end
  end
end
