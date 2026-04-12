module Api
  class LeadershipsController < ApplicationController
    before_action :set_leadership, only: [:show, :update, :destroy]

    def index
      @leaderships = Leadership.order(:display_order)
      render json: serialize_leaderships(@leaderships)
    end

    def show
      render json: serialize_leadership(@leadership)
    end

    def create
      @leadership = Leadership.new(leadership_params)

      if @leadership.save
        render json: serialize_leadership(@leadership), status: :created
      else
        render json: { errors: @leadership.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      if @leadership.update(leadership_params)
        render json: serialize_leadership(@leadership)
      else
        render json: { errors: @leadership.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      @leadership.destroy!
      head :no_content
    end

    private

    def set_leadership
      @leadership = Leadership.find(params[:id])
    end

    def leadership_params
      params.require(:leadership).permit(
        :name_ar, :name_en, :position_ar, :position_en,
        :description_ar, :description_en, :alt_text_ar, :alt_text_en,
        :display_order, :image
      )
    end

    def serialize_leaderships(leaderships)
      leaderships.map { |l| serialize_leadership(l) }
    end

    def serialize_leadership(leadership)
      {
        id: leadership.id,
        name_ar: leadership.name_ar,
        name_en: leadership.name_en,
        position_ar: leadership.position_ar,
        position_en: leadership.position_en,
        description_ar: leadership.description_ar,
        description_en: leadership.description_en,
        alt_text_ar: leadership.alt_text_ar,
        alt_text_en: leadership.alt_text_en,
        display_order: leadership.display_order,
        image_url: leadership.cached_image_url
      }
    end
  end
end
