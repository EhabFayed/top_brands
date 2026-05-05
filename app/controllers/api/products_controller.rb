module Api
  class ProductsController < ApplicationController
    before_action -> { require_role!(:admin, :manager, :editor) }, only: [:index, :show, :create, :update]
    before_action :require_admin_or_manager!, only: [:destroy]
    before_action :set_product, only: [:show, :update, :destroy]

    def index
      @pagy, @products = pagy(Product.order(:display_order), limit: params.fetch(:items, 20).to_i)
      render json: {
        pagination: pagination_metadata(@pagy),
        data: @products.map { |p| product_json(p) }
      }
    end

    def show
      render json: product_json(@product)
    end

    def create
      @product = Product.new(product_params)

      if @product.save
        render json: {message: "Product created successfully"}, status: :created
      else
        render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      if @product.update(product_params)
        render json: {message: "Product updated successfully"}, status: :ok
      else
        render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      @product.destroy!
      head :no_content
    end

    private

    def product_json(product)
      product.as_json(include: :faqs).merge(
        image_url: product.image.attached? ? product.cached_image_url : nil
      )
    end

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(
        :title_ar, :title_en, :description_ar, :description_en,
        :alt_text_ar, :alt_text_en, :display_order, :size, :brand_id, :image,:is_published
      )
    end
  end
end
