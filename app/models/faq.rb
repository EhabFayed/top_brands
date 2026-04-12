class Faq < ApplicationRecord
  belongs_to :parentable, polymorphic: true, optional: true

  validates :question_en, presence: true
  validates :answer_en, presence: true
end
