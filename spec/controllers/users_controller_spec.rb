require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  let(:valid_params) { { email: 'valid@email.com', password: 'match', password_confirmation: 'match' } }
  let(:invalid_params) { { email: 'valid@email.com', password: 'match', password_confirmation: 'mis-match' } }

  describe 'POST #create' do
    before { post :create, params: { user: params } }

    context 'with valid params' do
      let(:params) { valid_params }

      it { expect(response.status).to be 201 }
    end

    context 'with invalid params' do
      let(:params) { invalid_params }

      it { expect(response.status).to be 400 }
    end
  end
end
