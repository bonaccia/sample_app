require 'spec_helper'

describe "User pages" do
  subject { page }
  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end

  describe "signup" do
    before { visit signup_path }

    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
      describe "after submission should have an error message" do
        before { click_button submit }

        it { should have_title(full_title('Sign up')) }
        it { should have_content(/\berror/i) }
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",                   with: "Example User"
        fill_in "Email",                  with: "user@example.com"
        fill_in "Password",               with: "foobarxxxcom"
        fill_in "Confirmation",           with: "foobarxxxcom"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
      describe "after submission should have a welcome message" do
        before { click_button submit }

        it { should have_content(/\bwelcome/i) }
      end
    end
  end
end
