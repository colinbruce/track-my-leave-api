class User < ApplicationRecord

  validates :email, presence: true, uniqueness: true
  validates :email, format: {
    with: /@/,
    on: [:create, :update],
    allow_nil: false
  }

end
