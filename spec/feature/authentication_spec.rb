require "rails_helper"

feature "Authentication with basic backend" do
  before(:all) do
    Trestle.config.auth.backend = :basic
  end

  before(:each) do
    create_administrator
  end

  scenario "prevent unauthenticated access" do
    visit "/admin"
    expect(page).to have_current_path("/admin/login")
  end

  scenario "successful login" do
    login
    expect(page).to have_current_path("/admin")
    expect(page).to have_content("Admin User")
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

  def create_administrator
    Administrator.create!(first_name: "Admin", last_name: "User", email: "admin@example.com", password: "password")
  end
end
