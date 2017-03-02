require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  let(:valid_params) { { email: 'valid@email.com', password: 'match', password_confirmation: 'match' } }
  let(:invalid_params) { { email: 'valid@email.com', password: 'match', password_confirmation: 'mis-match' } }

  describe 'POST #create' do
    subject(:post_create) { post :create, params: { user: params } }

    context 'with valid params' do
      let(:params) { valid_params }

      it { expect(post_create.status).to be 201 }
    end

    context 'with invalid params' do
      let(:params) { invalid_params }

      it { expect(post_create.status).to be 400 }
    end
  end

  describe 'POST #confirm' do
    subject(:post_confirm) { post :confirm, params: { token: token } }

    context 'with an empty token' do
      let(:token) { nil }

      it { expect(post_confirm.status).to be 404 }
    end

    context 'with an expired token' do
      let(:user) { Timecop.freeze(Time.zone.now - 31.days) { create :user } }
      let(:token) { user.confirmation_token }

      it { expect(post_confirm.status).to be 404 }
    end

    context 'with a valid token' do
      let(:user) { create :user }
      let(:token) { user.confirmation_token }

      it { expect(post_confirm.status).to be 200 }
    end
  end

  describe 'POST #login' do
    subject(:post_login) { post :login, params: params }

    let(:user) { create :confirmed_user }
    let(:params) { { email: user.email, password: password } }

    context 'with valid email' do
      let(:password) { 'password' }

      it { expect(post_login.status).to be 200 }

      # it { expect(response.header['Content-Type']).to include 'application/json' }
    end

    context 'with invalid password' do
      let(:password) { 'wrong' }

      it { expect(post_login.status).to be 401 }
    end
  end
end
