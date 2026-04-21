class Brand < ApplicationRecord
  validates :title_ar, presence: true
  validates :title_en, presence: true
  has_many :products, dependent: :destroy
  has_one_attached :image

  after_commit :clear_image_cache, on: %i[update destroy]

  def cached_image_url
    return nil unless image.attached?

    Rails.cache.fetch("brand_image_url_#{id}", expires_in: 12.hours) do
      Rails.application.routes.url_helpers.rails_blob_url(image)
    end
  end

  private

  def clear_image_cache
    Rails.cache.delete("brand_image_url_#{id}")
  end
end
