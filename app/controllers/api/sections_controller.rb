module Api
  class SectionsController < ApplicationController
    before_action :set_section, only: [:show, :update, :destroy]

    # GET /api/sections?page=home
    def index
      sections = Section.all
      puts("paraaaaaaams#{params}")
      sections = sections.where(page: params[:page]) if params[:page].present?
      sections = sections.order(:position).includes(:contents)

      render json: serialize_sections(sections)
    end

    # GET /api/sections/:id
    def show
      render json: serialize_section(@section)
    end

    # POST /api/sections
    def create
      section = Section.new(section_params)

      if section.save
        render json: serialize_section(section), status: :created
      else
        render json: { errors: section.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/sections/:id
    def update
      if @section.update(section_params)
        render json: serialize_section(@section)
      else
        render json: { errors: @section.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # DELETE /api/sections/:id
    def destroy
      @section.destroy!
      head :no_content
    end

    private

    def set_section
      @section = Section.find(params[:id])
    end

    def section_params
      params.require(:section).permit(
        :page, :section_type, :position, settings: {},
        contents_attributes: [
          :id, :key, :value, :content_type, :position, :_destroy,
          content_photos_attributes: [:id, :photo, :alt_ar, :alt_en, :_destroy]
        ]
      )
    end

    def serialize_sections(sections)
      sections.map { |s| serialize_section(s) }
    end

    def serialize_section(section)
      {
        id:           section.id,
        page:         section.page.to_s,
        section_type: section.section_type.to_s,
        position:     section.position,
        settings:     section.settings,
        contents:     serialize_contents(section.contents),
        created_at:   section.created_at,
        updated_at:   section.updated_at
      }
    end

    def serialize_contents(contents)
      contents.map do |c|
        {
          id:           c.id,
          key:          c.key,
          value:        c.value,
          content_type: c.content_type,
          position:     c.position,
          photos:       c.content_photos.map { |cp| { id: cp.id, alt_ar: cp.alt_ar, alt_en: cp.alt_en, photo_url: cp.cached_photo_url } }
        }
      end
    end
  end
end
