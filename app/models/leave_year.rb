class LeaveYear < ActiveRecord::Base
  belongs_to :user, required: true

  validates :starts_on, :entitlement, :carried_forward, presence: true

  def self.current_for(user)
    LeaveYear.where(user: user).last
  end
end
