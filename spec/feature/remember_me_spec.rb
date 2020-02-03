require "rails_helper"

feature "Remember me" do
  before(:each) do
    create_administrator
  end

  scenario "remember login between sessions" do
    login_as_admin

    expire_cookies

    visit "/admin"
    expect(page).to have_current_path("/admin")
  end

  scenario "forget login after logging out" do
    login_as_admin
    logout

    expire_cookies

    visit "/admin"
    expect(page).to have_current_path("/admin/login")
  end

  def login_as_admin
    visit "/admin/login"

    fill_in "Email", with: "admin@example.com"
    fill_in "Password", with: "password"
    check "Remember me"
    click_button "Login"
  end

  def logout
    click_link "Logout"
  end

  def create_administrator
    Administrator.create!(first_name: "Admin", last_name: "User", email: "admin@example.com", password: "password")
  end
end
