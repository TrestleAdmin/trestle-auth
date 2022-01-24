require "rails_helper"

describe Trestle::Auth::ModelMethods do
  subject(:model) { Administrator }

  describe ".authenticate" do
    before(:each) do
      @user = model.create!(email: "test@example.com", password: "password", first_name: "Test", last_name: "Example")
    end

    it "returns the user matching the given identifier and password" do
      user = model.authenticate("test@example.com", "password")
      expect(user).to eq(@user)
    end

    it "returns nil if no user matches the given identifier" do
      user = model.authenticate("none@example.com", "")
      expect(user).to be_nil
    end

    it "returns nil if the password is incorrect for the user matching the given identifier" do
      user = model.authenticate("test@example.com", "incorrect")
      expect(user).to be_nil
    end
  end
end

describe Trestle::Auth::ModelMethods::Rememberable do
  let(:model) { Administrator }

  subject(:instance) { Administrator.create!(email: "test@example.com", password: "password", first_name: "Test", last_name: "Example") }

  describe "#remember_me!" do
    it "sets the remember token and expiration" do
      Timecop.freeze do
        subject.remember_me!

        expect(subject.remember_token).to match(/[A-Za-z0-9_-]{20}/)
        expect(subject.remember_token_expires_at).to be_within(1.second).of(Time.now + Trestle.config.auth.remember.for)
      end
    end
  end

  describe "#forget_me!" do
    before(:each) do
      subject.remember_me!
    end

    it "resets the remember token and expiration" do
      subject.forget_me!

      expect(subject.remember_token).to be_nil
      expect(subject.remember_token_expires_at).to be_nil
    end
  end

  describe "#remember_token_expired?" do
    it "returns false if the remember token exists and is not expired" do
      subject.remember_me!
      expect(subject.remember_token_expired?).to be false
    end

    it "returns true if the remember token is nil" do
      expect(subject.remember_token_expired?).to be true
    end

    it "returns true if the remember token exists but is expired" do
      subject.remember_me!

      Timecop.travel(Time.now + Trestle.config.auth.remember.for + 1.minute) do
        expect(subject.remember_token_expired?).to be true
      end
    end
  end

  describe ".authenticate_with_remember_token" do
    it "returns the user matching the non-expired remember token" do
      subject.remember_me!
      expect(model.authenticate_with_remember_token(subject.remember_token)).to eq(subject)
    end

    it "returns nil if no user matches the remember token" do
      expect(model.authenticate_with_remember_token("invalid")).to be_nil
    end

    it "returns nil if the remember token has expired" do
      subject.remember_me!

      Timecop.travel(Time.now + Trestle.config.auth.remember.for + 1.minute) do
        expect(model.authenticate_with_remember_token(subject.remember_token)).to be_nil
      end
    end
  end
end
