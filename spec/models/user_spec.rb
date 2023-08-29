# require 'rails_helper'

# RSpec.describe User, type: :model do

#   context :email do
#     it 'is invalid without email' do
#       user = build(:user, email: nil)
#       user.valid?
#       expect(user.errors[:email]).to include("can't be blank")
#     end

#     it "is invalid with a duplicate email address" do
#       create(:user, email: 'testqa+1@bitcot.com')
#       user = build(:user, email: 'testqa+1@bitcot.com')
#       user.valid?
#       expect(user.errors[:email]).to include("has already been taken")
#     end
#   end
# end
