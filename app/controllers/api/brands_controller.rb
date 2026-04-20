module Api
  class BrandsController < ApplicationController
    before_action :set_brand, only: [:show, :update, :destroy]

    def index
      @brands = Brand.try(:includes, :products).all
      render json: serialize_brands(@brands)
    end

    def show
      render json: serialize_brand(@brand)
    end

    def create
      @brand = Brand.new(brand_params)

      if @brand.save
        render json: {message: "Brand created successfully"}, status: :created
      else
        render json: { errors: @brand.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      if @brand.update(brand_params)
        render json: {message: "Brand updated successfully"}, status: :ok
      else
        render json: { errors: @brand.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      @brand.destroy!
      head :no_content
    end

    private

    def set_brand
      @brand = Brand.find(params[:id])
    end

    def brand_params
      params.require(:brand).permit(:title_ar, :title_en, :alt_text_ar, :alt_text_en, :image,:is_published)
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
        is_published: brand.is_published,
        description_ar: brand.description_ar,
        description_en: brand.description_en,
        meta_title_ar: brand.meta_title_ar,
        meta_title_en: brand.meta_title_en,
        meta_description_ar: brand.meta_description_ar,
        meta_description_en: brand.meta_description_en,
        products: brand.try(:products).map { |p| { id: p.id, title_ar: p.title_ar, title_en: p.title_en } }
      }
    end
  end
end
