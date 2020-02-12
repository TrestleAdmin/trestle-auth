require "rails_helper"

feature "Authentication with Devise backend" do
  before(:all) do
    Trestle.config.auth.backend = :devise
    Trestle.config.auth.warden.scope = :devise_user
  end

  before(:each) do
    create_devise_user
  end

  scenario "prevent unauthenticated access" do
    visit "/admin"
    expect(page).to have_current_path("/admin/login")
  end

  scenario "successful login" do
    login
    expect(page).to have_current_path("/admin")
    expect(page).to have_content("admin@example.com")
  end

  scenario "failed login" do
    login(password: "incorrect")
    expect(page).to have_current_path("/admin/login")
    expect(page).to have_content("Incorrect login details")
  end

  context "remember me" do
    scenario "remember login between sessions" do
      login(remember_me: true)

      expire_cookies

      visit "/admin"
      expect(page).to have_current_path("/admin")
    end

    scenario "forget login after logging out" do
      login(remember_me: true)
      logout

      expire_cookies

      visit "/admin"
      expect(page).to have_current_path("/admin/login")
    end
  end

  def create_devise_user
    DeviseUser.create!(email: "admin@example.com", password: "password")
  end
end
