require "spec_helper"

require "generators/trestle/auth/admin/admin_generator"

describe Trestle::Auth::Generators::AdminGenerator, type: :generator do
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
        subject { file("app/admin/auth/administrators_admin.rb") }

        it { is_expected.to exist }
        it { is_expected.to have_correct_syntax }
        it { is_expected.to contain "Trestle.resource(:administrators, model: Administrator, scope: Auth) do" }
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
        subject { file("app/admin/auth/users_admin.rb") }

        it { is_expected.to exist }
        it { is_expected.to have_correct_syntax }
        it { is_expected.to contain "Trestle.resource(:users, model: User, scope: Auth) do" }
        it { is_expected.to contain "if Devise.sign_in_after_reset_password" }
      end
    end
  end
end
