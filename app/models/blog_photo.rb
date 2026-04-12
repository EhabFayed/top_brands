class BlogPhoto < ApplicationRecord
  belongs_to :blog
  has_one_attached :photo
  after_commit :clear_photo_cache, on: %i[update destroy]

  # validates :alt_ar, :alt_en, presence: true
  def cached_photo_url
    return nil unless photo.attached?

    Rails.cache.fetch("plog_photo_url_#{id}", expires_in: 12.hours) do
      Rails.application.routes.url_helpers.url_for(photo)
    end
  end

  private

  def clear_photo_cache
    Rails.cache.delete("plog_photo_url_#{id}")
  end
end
