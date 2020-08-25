require "spec_helper"

describe Trestle::Auth::Configuration do
  subject(:config) { Trestle::Auth::Configuration.new }

  let(:model) { double }
  let(:user) { double(locale: "en-AU", time_zone: "Australia/Adelaide") }
  let(:params) { double }
  let(:block) { -> {} }

  let(:login_url) { "/admin/login" }

  it "has a user_class configuration option" do
    expect(config).to have_accessor(:user_class).with_default(::Administrator)
  end

  it "has a user_scope configuration option" do
    expect(config).to have_accessor(:user_scope).with_default(::Administrator)
  end

  it "has a user_admin configuration option" do
    expect(config).to have_accessor(:user_admin)
  end

  it "has an authenticate_with configuration option" do
    expect(config).to have_accessor(:authenticate_with).with_default(:email)
  end

  it "has an authenticate configuration block option" do
    expect(config).to have_accessor(:authenticate)

    config.authenticate = ->(params) {
      model.authenticate(params)
    }

    expect(model).to receive(:authenticate).with(params)
    config.authenticate(params)
  end

  it "has a find_user configuration block option" do
    expect(config).to have_accessor(:find_user)

    config.find_user = ->(id) {
      model.find_user(id)
    }

    expect(model).to receive(:find_user).with(123)
    config.find_user(123)
  end

  it "has a human_attribute_name configuration block option" do
    expect(config).to have_accessor(:human_attribute_name)

    config.human_attribute_name = ->(field) { field.to_s.upcase }

    expect(config.human_attribute_name(:email)).to eq("EMAIL")
  end

  it "has a default human_attribute_name block" do
    Trestle.config.auth.user_class = model

    expect(model).to receive(:human_attribute_name).with(:email).and_return("Email address")
    expect(config.human_attribute_name(:email)).to eq("Email address")
  end

  it "has an avatar configuration block option" do
    config.avatar = block
    expect(config.avatar).to eq(block)
  end

  it "has a format_user_name configuration block option" do
    config.format_user_name = block
    expect(config.format_user_name).to eq(block)
  end

  it "has a locale configuration block option" do
    config.locale = block
    expect(config.locale).to eq(block)
  end

  it "has a default locale block" do
    expect(config.locale.call(user)).to eq("en-AU")
  end

  it "has a time_zone configuration block option" do
    config.time_zone = block
    expect(config.time_zone).to eq(block)
  end

  it "has a default time_zone block" do
    expect(config.time_zone.call(user)).to eq("Australia/Adelaide")
  end

  it "has an enable_login configuration option" do
    expect(config).to have_accessor(:enable_login).with_default(true)
  end

  it "has an enable_logout configuration option" do
    expect(config).to have_accessor(:enable_logout).with_default(true)
  end

  it "has a login_url configuration block option" do
    config.login_url = block
    expect(config.login_url).to eq(block)
  end

  it "has a default login_url block" do
    expect(instance_exec(&config.login_url)).to eq("/admin/login")
  end

  it "has a redirect_on_login configuration block option" do
    config.redirect_on_login = block
    expect(config.redirect_on_login).to eq(block)
  end

  it "has a default redirect_on_login block" do
    expect(instance_exec(&config.redirect_on_login)).to eq("/admin")
  end

  it "has a redirect_on_logout configuration block option" do
    config.redirect_on_logout = block
    expect(config.redirect_on_logout).to eq(block)
  end

  it "has a default redirect_on_logout block" do
    expect(instance_exec(&config.redirect_on_logout)).to eq("/admin/login")
  end

  it "has a logo configuration option" do
    expect(config).to have_accessor(:logo)
  end

  describe "#backend=" do
    it "sets the backend configuration option with :basic" do
      config.backend = :basic
      expect(config.backend).to eq(Trestle::Auth::Backends::Basic)
    end

    it "sets the backend configuration option with :devise" do
      config.backend = :devise
      expect(config.backend).to eq(Trestle::Auth::Backends::Devise)
    end

    it "sets the backend configuration option with :warden" do
      config.backend = :warden
      expect(config.backend).to eq(Trestle::Auth::Backends::Warden)
    end

    it "sets the backend configuration option with a custom class" do
      custom_class = Class.new

      config.backend = custom_class
      expect(config.backend).to eq(custom_class)
    end

    it "raises ArgumentError if an invalid option is provided" do
      expect {
        config.backend = :invalid
      }.to raise_error(ArgumentError, "Invalid authentication backend: :invalid")
    end
  end

  describe "#authorize_with" do
    it "sets the global authorization adapter with :cancan" do
      config.authorize_with cancan: -> { Ability }
      expect(config.authorization_adapter).to be < Trestle::Auth::CanCanAdapter
      expect(config.authorization_adapter.ability_class).to eq(Ability)
    end

    it "sets the global authorization adapter with :pundit" do
      config.authorize_with pundit: -> { TestPolicy }
      expect(config.authorization_adapter).to be < Trestle::Auth::PunditAdapter
      expect(config.authorization_adapter.policy_class).to eq(TestPolicy)
    end

    it "sets the global authorization adapter with a custom class" do
      custom_class = Class.new

      config.authorize_with -> { custom_class }
      expect(config.authorization_adapter).to eq(custom_class)
    end

    it "raises ArgumentError if an invalid option is provided" do
      expect {
        config.authorize_with invalid: :option
      }.to raise_error(ArgumentError, "unrecognized options")
    end
  end

  describe "#authorize" do
    it "sets the global authorization block using the built-in DSL" do
      config.authorize do
        access! { current_user.admin? }
      end

      expect(config.authorization_adapter).to be < Trestle::Auth::BuiltinAdapter
    end
  end

  it "has a configuration set for remember options" do
    expect(config.remember).to be_an_instance_of(Trestle::Auth::Configuration::Rememberable)
  end

  describe Trestle::Auth::Configuration::Rememberable do
    subject(:config) { Trestle::Auth::Configuration::Rememberable.new }

    let(:user) { double(remember_token: "token", remember_token_expires_at: 2.weeks.from_now) }

    it "has an enabled configuration option" do
      expect(config).to have_accessor(:enabled).with_default(true)
    end

    it "has a cookie duration (#for) configuration option" do
      expect(config).to have_accessor(:for).with_default(2.weeks)
    end

    it "has an authenticate configuration block option" do
      expect(config).to have_accessor(:authenticate)

      config.authenticate = ->(token) {
        model.authenticate_with_remember_token(token)
      }

      expect(model).to receive(:authenticate_with_remember_token).with("token")
      config.authenticate("token")
    end

    it "has a remember_me configuration block option" do
      expect(config).to have_accessor(:remember_me)

      config.remember_me = ->(user) {
        user.remember!
      }

      expect(user).to receive(:remember!)
      config.remember_me(user)
    end

    it "has a default remember_me block" do
      expect(user).to receive(:remember_me!)
      config.remember_me(user)
    end

    it "has a forget_me configuration block option" do
      expect(config).to have_accessor(:forget_me)

      config.forget_me = ->(user) {
        user.forget!
      }

      expect(user).to receive(:forget!)
      config.forget_me(user)
    end

    it "has a default forget_me block" do
      expect(user).to receive(:forget_me!)
      config.forget_me(user)
    end

    it "has a cookie configuration block option" do
      expect(config).to have_accessor(:cookie)
      expect(config.cookie(user)).to eq({ value: user.remember_token, expires: user.remember_token_expires_at })
    end
  end

  it "has a configuration set for Warden options" do
    expect(config.warden).to be_an_instance_of(Trestle::Auth::Configuration::Warden)
  end

  describe Trestle::Auth::Configuration::Warden do
    subject(:config) { Trestle::Auth::Configuration::Warden.new }

    it "has a scope configuration option" do
      expect(config).to have_accessor(:scope)
    end
  end
end
