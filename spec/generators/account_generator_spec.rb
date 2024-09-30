require "spec_helper"

require "generators/trestle/auth/account/account_generator"

describe Trestle::Auth::Generators::AccountGenerator, type: :generator do
  destination File.expand_path("../../../tmp", __FILE__)

  before do
    prepare_destination
  end

  context "for a regular user model" do
    describe "the generated files" do
      before do
        run_generator
      end

      describe "the admin resource" do
        subject { file("app/admin/auth/account_admin.rb") }

        it { is_expected.to exist }
        it { is_expected.to have_correct_syntax }
        it { is_expected.to contain "Trestle.resource(:account, model: Administrator, scope: Auth, singular: true) do" }
        it { is_expected.to contain "params.require(:account).permit(:email, :first_name, :last_name, :password, :password_confirmation)" }
        it { is_expected.not_to contain "if Devise.sign_in_after_reset_password" }
      end
    end
  end

  context "for a Devise user model" do
    describe "the generated files" do
      before do
        run_generator %w(User --devise)
      end

      describe "the admin resource" do
        subject { file("app/admin/auth/account_admin.rb") }

        it { is_expected.to exist }
        it { is_expected.to have_correct_syntax }
        it { is_expected.to contain "Trestle.resource(:account, model: User, scope: Auth, singular: true) do" }
        it { is_expected.to contain "params.require(:account).permit(:email, :password, :password_confirmation)" }
        it { is_expected.to contain "if Devise.sign_in_after_reset_password" }
      end
    end
  end
end
