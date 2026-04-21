class Product < ApplicationRecord
  has_many :faqs, as: :parentable, dependent: :destroy
  belongs_to :brand
  validates :title_ar, presence: true
  validates :title_en, presence: true
  has_one_attached :image
  after_commit :clear_image_cache, on: %i[update destroy]

  def cached_image_url
    return nil unless image.attached?

    Rails.cache.fetch("product_image_url_#{id}", expires_in: 12.hours) do
      Rails.application.routes.url_helpers.url_for(image)
    end
  end

  private

  def clear_image_cache
    Rails.cache.delete("product_image_url_#{id}")
  end
end
