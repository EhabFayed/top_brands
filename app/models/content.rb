class Content < ApplicationRecord
  belongs_to :parentable, polymorphic: true
  validates :key, presence: true
  has_many :content_photos, dependent: :destroy
  accepts_nested_attributes_for :content_photos, allow_destroy: true, reject_if: :all_blank
end
