require 'rails_helper'

RSpec.describe User do

  subject(:user) { build :user, email: email }
  let(:email) { 'valid@email.com' }

  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_uniqueness_of :email }

  describe 'email validation' do
    subject(:email_validity) { user.valid? }

    context 'when sent a valid email' do
      it { is_expected.to be true }
    end

    context 'when sent an invalid email' do
      let(:email) { 'testuser.con' }

      it { is_expected.to be false }
    end
  end
end
