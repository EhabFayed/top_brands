class Blog < ApplicationRecord
  extend Enumerize

  # validates :title_ar, :title_en, presence: true
  # validates :slug, presence: true, uniqueness: true
  # validates :slug_ar, uniqueness: true, presence: true
  # validates :blog_photos, length: { maximum: 2, message: "can have at most 2 photos" }


  CATEGORIES = {
    none: 0,
    Market_Insights: 1,
    Consumer_Behavior: 2,
    Retail_Trends: 3,
    Distribution: 4,
    Product_Categories: 5,
    Logistics: 6,
    Partnerships: 7,
    Digital_Trends: 8,
    Quality_Safety: 9
  }
  enumerize :category, in: CATEGORIES

  scope :published, -> { where(is_published: true) }

  has_many :faqs, as: :parentable, dependent: :destroy
  has_many :blog_contents, dependent: :destroy
  # has_many :blog_photos, dependent: :destroy
  # accepts_nested_attributes_for :blog_photos, allow_destroy: true, reject_if: :all_blank

  has_one_attached :image

  after_commit :clear_image_cache, on: %i[update destroy]

  def cached_image_url
    return nil unless image.attached?

    Rails.cache.fetch("blog_image_url_#{id}", expires_in: 12.hours) do
      Rails.application.routes.url_helpers.url_for(image)
    end
  end

  private

  def clear_image_cache
    Rails.cache.delete("blog_image_url_#{id}")
  end

  # app/models/blog.rb
  def self.find_by_any_slug(slug)
    find_by("slug = :s OR slug_ar = :s", s: slug)
  end

end
