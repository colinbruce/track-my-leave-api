class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :email, format: {
    with: /@/,
    on: [:create, :update],
    allow_nil: false
  }

  before_save :downcase_email
  before_create :generate_confirmation_instructions

  def downcase_email
    self.email = email.delete(' ').downcase
  end

  def generate_confirmation_instructions
    self.confirmation_token = SecureRandom.hex(10)
    self.confirmation_sent_at = Time.zone.now.utc
  end

  def confirmation_token_valid?
    (confirmation_sent_at + 30.days) > Time.zone.now.utc
  end

  def mark_as_confirmed!
    self.confirmation_token = nil
    self.confirmed_at = Time.zone.now.utc
    save
  end
end
