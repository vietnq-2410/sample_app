class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  before_save :downcase_email
  validates :name, presence: true
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX},
                    uniqueness: true
  validates :password, presence: true

  private

  def downcase_email
    email.downcase!
  end

  has_secure_password
end