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

    context 'with valid password' do
      let(:password) { 'password' }

      context 'when user has verified their account' do
        it { expect(post_login.status).to be 200 }

        context 'returns a JWT' do
          subject(:decoded_jwt) { JWT.decode(JSON.parse(post_login.body)['auth_token'], Rails.application.secrets.secret_key_base) }

          describe 'with valid claims' do
            subject(:claims) { decoded_jwt[0] }

            it { expect(claims['iss']).to eq('issuer_name') }
            it { expect(claims['aud']).to eq('client') }
          end

          describe 'headers' do
            subject(:header) { decoded_jwt[1] }

            it { expect(header['typ']).to eq 'JWT' }
            it { expect(header['alg']).to eq 'HS256' }
          end
        end
      end

      context 'when the account is un-verified' do
        subject(:json_response) { JSON.parse(post_login.body)['error'] }
        let(:user) { create :user }

        it { expect(post_login.status).to be 401 }
        it { is_expected.to eq 'Email not verified' }
      end
    end

    context 'with invalid password' do
      let(:password) { 'wrong' }

      it { expect(post_login.status).to be 401 }
    end
  end
end
