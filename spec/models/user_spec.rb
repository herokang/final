require 'rails_helper'

describe User do
  it "should create a new instance given valid attributes" do
    User.create!(
      name: "name",
      email:    "user@example.com",
      password: "password"
    )
  end

  it "should have a valid factory" do
    expect(FactoryGirl.build(:user)).to be_valid
  end

  let(:user) { create(:user) }

  subject do
    user = User.new
    user.valid?
    user
  end
  describe "#init" do
    it "returns true if userType is known" do
      expect(user.userType).to eq 0
    end
    it "returns ture if verified is false" do
    	expect(user.verified).to eql false
    end
    it "returns ture if avatar is nil" do
    	expect(user.avatar).to eql nil	
    end
  end
end