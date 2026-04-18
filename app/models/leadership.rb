class Leadership < ApplicationRecord
  has_one_attached :image
  validates :name_ar, presence: true
  validates :name_en, presence: true

  def cached_image_url
    return nil unless image.attached?

    Rails.cache.fetch("leadership_image_url_#{id}", expires_in: 12.hours) do
      Rails.application.routes.url_helpers.rails_blob_url(image)
    end
  end

  private

  def clear_image_cache
    Rails.cache.delete("leadership_image_url_#{id}")
  end
end
