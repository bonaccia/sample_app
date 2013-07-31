require 'spec_helper'

describe User do

  before { @user = User.new(name: "squid", email: "harmless@decap.od", 
                            password: "foobar", password_confirmation: "foobar" ) }

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:disabled) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }

  it { should be_valid }

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "N" * 51 }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when email is already taken" do
    before do 
      @user.dup.save 
      @user.email.upcase!
    end
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    %w[user@foo,com user_at_goo.com example.user@foo. foo@bar_baz.com foo@bar+baz.com].each do |invalid_address|
      before { @user.email = invalid_address }
      it { should_not be_valid }
    end
  end
  describe "when email format is valid" do
    %w[user@foo.COM A_US_ER@f.b.com example.user@foo.co.uk foo+baz@barbaz.cn].each do |valid_address|
      before { @user.email = valid_address }
      it { should be_valid }
    end
  end

  describe "when password is not present" do
    before { @user.password = @user.password_confirmation = " " }
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end
end
