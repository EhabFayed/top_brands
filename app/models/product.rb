class Product < ApplicationRecord
  has_many :faqs, as: :parentable, dependent: :destroy
  belongs_to :brand
  validates :title_ar, presence: true
  validates :title_en, presence: true
end
