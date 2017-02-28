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

  describe 'callbacks' do
    context 'before_save' do
      subject { user.email }
      before { user.save }

      describe 'downcase`s emails' do
        let(:email) { 'UPPERCASE@email.com' }
        it { is_expected.to eq 'uppercase@email.com' }
      end

      describe 'removes spaces' do
        let(:email) { 'remove space@email.com' }

        it { is_expected.to eq 'removespace@email.com' }
      end
    end

    context 'before_create' do
      subject(:user) { create :user, email: email }

      describe 'generate_confirmation_instructions' do
        describe 'confirmation_token' do
          subject { user.confirmation_token }

          it { is_expected.to be_a String }
        end

        describe 'confirmation_sent_at' do
          subject { user.confirmation_sent_at }

          it { is_expected.to be_a Time }
        end
      end
    end
  end

  describe '#confirmation_token_valid?' do
    subject { user.confirmation_token_valid? }

    let(:user) { Timecop.freeze(confirmation_sent) { create :user } }

    context 'when the token is out of date' do
      let(:confirmation_sent) { 31.days.ago }

      it { is_expected.to be false }
    end

    context 'when the token is in date' do
      let(:confirmation_sent) { 10.days.ago }

      it { is_expected.to be true }
    end
  end

  describe '#mark_as_confirmed!' do
    before { Timecop.freeze(2017, 1, 1, 10, 0) { user.mark_as_confirmed! } }

    let(:user) { create :user }

    it { expect(user.confirmation_token).to be nil }
    it { expect(user.confirmed_at).to eq Time.zone.parse('2017-01-01 10:00:00') }
  end
end
