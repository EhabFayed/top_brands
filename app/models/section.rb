class Section < ApplicationRecord
  extend Enumerize

  PAGES = {
    home:              "0",
    branding:          "1",
    web_design:        "2",
    graphic_design:    "3",
    digital_marketing: "4",
    e_commerce:        "5"
  }.freeze

  SECTION_TYPES = {
    hero: "0",
    cta:  "1"
  }.freeze

  enumerize :page,         in: PAGES,         predicates: true
  enumerize :section_type, in: SECTION_TYPES, predicates: true

  has_many :contents, -> { order(:position) }, as: :parentable, dependent: :destroy
  accepts_nested_attributes_for :contents, allow_destroy: true

  validates :page,         presence: true
  validates :section_type, presence: true
end
