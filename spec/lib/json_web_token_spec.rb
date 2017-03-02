require 'rails_helper'

RSpec.describe JsonWebToken do

  describe '.encode' do
    subject(:encoded_jwt) { described_class.encode('test': 'data') }

    it { is_expected.to be_a String }

    describe 'it should return a JWT than can be decoded' do
      subject(:decoded_jwt) { JWT.decode(encoded_jwt, Rails.application.secrets.secret_key_base) }

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
end
