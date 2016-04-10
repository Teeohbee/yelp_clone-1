require 'rails_helper'

RSpec.describe Restaurant, type: :model do
    it { should have_many(:reviews).dependent(:destroy) }

    context 'relationship with users' do
      it { is_expected.to belong_to :user }
    end
end
