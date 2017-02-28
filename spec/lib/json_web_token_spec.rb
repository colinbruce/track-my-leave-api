require 'rails_helper'

RSpec.describe JsonWebToken do

  describe '.encode' do
    subject { described_class.encode("test": "data") }

    it { is_expected.to be_a String }
  end
end
