class BlogConPhoto < ApplicationRecord
  belongs_to :blog_content

  has_one_attached :photo

  validates :alt_ar, :alt_en, presence: true
  after_commit :clear_photo_cache, on: %i[update destroy]

  def cached_photo_url
    return nil unless photo.attached?

    Rails.cache.fetch("blog_con_photo_url_#{id}", expires_in: 12.hours) do
      Rails.application.routes.url_helpers.url_for(photo)
    end
  end

  private

  def clear_photo_cache
    Rails.cache.delete("blog_con_photo_url_#{id}")
  end
end
