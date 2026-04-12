module Api
  class ProductsController < ApplicationController
    before_action :set_product, only: [:show, :update, :destroy]

    def index
      @products = Product.order(:display_order)
      render json: @products, include: [:faqs]
    end

    def show
      render json: @product, include: [:faqs]
    end

    def create
      @product = Product.new(product_params)

      if @product.save
        render json: @product, status: :created
      else
        render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      if @product.update(product_params)
        render json: @product
      else
        render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      @product.destroy!
      head :no_content
    end

    private

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(
        :title_ar, :title_en, :description_ar, :description_en,
        :alt_text_ar, :alt_text_en, :is_international, :display_order, :size, :brand_id
      )
    end
  end
end
