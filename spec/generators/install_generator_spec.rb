require "spec_helper"

require "generators/trestle/auth/install/install_generator"

describe Trestle::Auth::Generators::InstallGenerator, type: :generator do
  destination File.expand_path("../../../tmp", __FILE__)

  let(:generator_params) { [] }

  before do
    prepare_destination

    allow(generator(generator_params)).to receive(:generate)
    stub_file "config/initializers/trestle.rb", configuration
  end

  let(:configuration) do
    <<~EOF
      Trestle.configure do |config|
      end
    EOF
  end

  context "regular mode" do
    it "generates a model" do
      expect(generator(generator_params)).to receive(:generate).with("trestle:auth:model", "Administrator")
      run_generator generator_params
    end

    it "generates an admin resource" do
      expect(generator(generator_params)).to receive(:generate).with("trestle:auth:admin", "Administrator")
      run_generator generator_params
    end

    it "generates an account resource" do
      expect(generator(generator_params)).to receive(:generate).with("trestle:auth:account", "Administrator")
      run_generator generator_params
    end

    context "when --skip-account is passed" do
      let(:generator_params) { %w(--skip-account) }

      it "does not generate an account resource" do
        expect(generator(generator_params)).not_to receive(:generate).with("trestle:auth:account", "Administrator")
        run_generator generator_params
      end
    end

    describe "the generated files" do
      before do
        run_generator generator_params
      end

      describe "the Trestle configuration" do
        subject { file("config/initializers/trestle.rb") }

        it { is_expected.to exist }
        it { is_expected.to have_correct_syntax }
        it { is_expected.to contain "config.auth.user_class = -> { Administrator }" }
        it { is_expected.to contain "config.auth.user_admin = -> { :\"auth/account\" }" }
        it { is_expected.not_to contain "config.auth.backend = :devise" }
      end
    end
  end

  context "Devise mode (--devise)" do
    let(:generator_params) { %w(User --devise) }

    it "does not generate a model" do
      expect(generator(generator_params)).not_to receive(:generate).with("trestle:auth:model", "User")
      run_generator generator_params
    end

    it "generates an admin resource" do
      expect(generator(generator_params)).to receive(:generate).with("trestle:auth:admin", "User", "--devise")
      run_generator generator_params
    end

    it "generates an account resource" do
      expect(generator(generator_params)).to receive(:generate).with("trestle:auth:account", "User", "--devise")
      run_generator generator_params
    end

    context "when --skip-account is passed" do
      let(:generator_params) { %w(User --devise --skip-account) }

      it "does not generate an account resource" do
        expect(generator(generator_params)).not_to receive(:generate).with("trestle:auth:account", "User", "--devise")
        run_generator generator_params
      end
    end

    describe "the generated files" do
      before do
        run_generator generator_params
      end

      describe "the Trestle configuration" do
        subject { file("config/initializers/trestle.rb") }

        it { is_expected.to exist }
        it { is_expected.to have_correct_syntax }
        it { is_expected.to contain "config.auth.backend = :devise" }
        it { is_expected.to contain "config.auth.warden.scope = :user" }
        it { is_expected.to contain "config.auth.user_class = -> { User }" }
        it { is_expected.to contain "config.auth.user_admin = -> { :\"auth/account\" }" }
        it { is_expected.to contain "config.auth.authenticate_with = -> { Devise.authentication_keys.first }" }
      end
    end
  end
end
