require "rails_helper"

feature "Authentication" do
  before(:each) do
    create_administrator
  end

  scenario "prevent unauthenticated access" do
    visit "/admin"
    expect(page).to have_current_path("/admin/login")
  end

  scenario "successful login" do
    visit "/admin/login"

    fill_in "Email", with: "admin@example.com"
    fill_in "Password", with: "password"
    click_button "Login"

    expect(page).to have_current_path("/admin")
  end

  scenario "failed login" do
    visit "/admin/login"

    fill_in "Email", with: "admin@example.com"
    fill_in "Password", with: "incorrect"
    click_button "Login"

    expect(page).to have_current_path("/admin/login")
    expect(page).to have_content("Incorrect login details")
  end

  def create_administrator
    Administrator.create!(first_name: "Admin", last_name: "User", email: "admin@example.com", password: "password")
  end
end
