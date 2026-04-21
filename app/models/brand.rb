class Brand < ApplicationRecord
  validates :title_ar, presence: true
  validates :title_en, presence: true
  has_many :products, dependent: :destroy
  has_one_attached :image

  after_commit :clear_image_cache, on: %i[update destroy]

  def cached_image_url
    return nil unless image.attached?

    Rails.cache.fetch("brand_image_url_#{id}", expires_in: 12.hours) do
      Rails.application.routes.url_helpers.url_for(image)
    end
  end

  validate :limit_highlighted_brands, if: :will_save_change_to_is_highlighted?

  private


  def limit_highlighted_brands
    if Brand.where(is_highlighted: true).where.not(id: id).count >= 12
      errors.add(:is_highlighted, "Maximum limit of 12 highlighted brands reached")
    end
  end

  def clear_image_cache
    Rails.cache.delete("brand_image_url_#{id}")
  end
end
