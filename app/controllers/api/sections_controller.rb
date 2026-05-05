module Api
  class SectionsController < ApplicationController
    before_action :require_admin_or_manager!
    before_action :set_section, only: [:show, :update, :destroy]

    # GET /api/sections?page=home
    def index
      sections = Section.all
      sections = sections.where(page: params[:page]) if params[:page].present?
      sections = sections.order(:position).includes(:contents)

      render json: serialize_sections(sections)
    end

    # GET /api/sections/:id
    def show
      render json: serialize_section(@section)
    end

    # POST /api/sections
    # A section_type on a given page is unique — find the existing one or create it.
    def create
      section = Section.find_or_initialize_by(
        page: section_params[:page],
        section_type: section_params[:section_type]
      )
      section.assign_attributes(section_params)

      status = section.new_record? ? :created : :ok

      if section.save
        render json: serialize_section(section), status: status
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
        :page, :section_type, :position, :image, settings: {},
        contents_attributes: [
          :id, :key, :value_ar, :value_en, :content_type, :position, :_destroy,
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
        image_url:    section.image.attached? ? section.cached_image_url : nil,
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
          value_ar:        c.value_ar,
          value_en:        c.value_en,
          content_type: c.content_type,
          position:     c.position,
        }
      end
    end
  end
end
