require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin" do
    before { visit signin_path }

    it { should have_content /\bsign(\s*|-)in\b/i }
    it { should have_title  "Sign in" }

    describe "with invalid credentials" do
      before { click_button "Sign in" }

      it { should have_title  "Sign in" }
      it { should have_error_message 'Invalid' }
      describe "then visiting another page" do
          before { click_link "Home" }
          it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe "with valid credentials" do
      let(:user) { FactoryGirl.create(:user) }
      before { valid_signin(user) }

      it { should have_title(user.name) }
      it { should have_link('Profile',     href: user_path(user)) }
      it { should have_link('Sign out',    href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }
      describe "followed by signout" do
        before { click_link "Sign out" } 
        it { should have_link('Sign in') }
      end
    end
  end
end
