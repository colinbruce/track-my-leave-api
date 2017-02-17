require 'rails_helper'

RSpec.describe LeaveYear, type: :model do
  let(:leave_year) { build :leave_year }

  describe 'validations' do
    it { is_expected.to validate_presence_of :starts_on }
    it { is_expected.to validate_presence_of :entitlement }
    it { is_expected.to validate_presence_of :carried_forward }
  end
end
