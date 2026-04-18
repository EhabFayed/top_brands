class BlogContent < ApplicationRecord
  belongs_to :blog
  has_many :blog_con_photos, dependent: :destroy
  accepts_nested_attributes_for :blog_con_photos, allow_destroy: true

  validates :content_ar, :content_en, presence: true
end