class User < ApplicationRecord
  has_secure_password
  has_one_attached :image
  enum :role, { editor: 0, manager: 1, admin: 2 }
  validates :name, presence: true
  # validates :email,presence: true,uniqueness: true,format: {  with: /\A[\w+\-.]+@milaknights\.com\z/i,  message: "must be a milaknights.com email"}
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  validate :email_unchanged, on: :update

  def email_unchanged
    if email_changed?
      errors.add(:email, "cannot be changed once set")
    end
  end
end
