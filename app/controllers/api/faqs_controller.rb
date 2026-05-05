module Api
  class FaqsController < ApplicationController
    before_action :require_admin_or_manager!
    before_action :set_faq, only: [:show, :update, :destroy]

    def index
      @faqs = Faq.all

      # Optional filtering by parentable
      if params[:parentable_type] && params[:parentable_id]
        @faqs = @faqs.where(
          parentable_type: params[:parentable_type],
          parentable_id: params[:parentable_id]
        )
      end

      render json: @faqs
    end

    def show
      render json: @faq
    end

    def create
      @faq = Faq.new(faq_params)

      if @faq.save
        render json: @faq, status: :created
      else
        render json: { errors: @faq.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      if @faq.update(faq_params)
        render json: @faq
      else
        render json: { errors: @faq.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      @faq.destroy!
      head :no_content
    end

    private

    def set_faq
      @faq = Faq.find(params[:id])
    end

    def faq_params
      params.require(:faq).permit(
        :question_ar, :question_en, :answer_ar, :answer_en,
        :parentable_type, :parentable_id, :is_published
      )
    end
  end
end
