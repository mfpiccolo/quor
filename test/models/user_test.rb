require "test_helper"

describe User do
  before { @user = FactoryGirl.build(:user) }

  it { @user.valid?.must_equal true }
  it { @user.must_respond_to(:email) }

end
