require "rails_helper"

feature "Authorization using CanCanCan" do
  before(:all) do
    Trestle.config.auth.backend = :basic
  end

  before(:each) do
    @regular_admin = create_administrator
    @super_admin = create_administrator(email: "super@example.com", super: true)
  end

  def create_administrator(attrs={})
    Administrator.create!({ first_name: "Admin", last_name: "User", email: "admin@example.com", password: "password" }.merge(attrs))
  end

  scenario "prevent access to unauthorized users" do
    login
    visit "/admin/cancancan"

    expect(page).to have_current_path("/admin")
    expect(page).to have_content("You are not authorized to access this page.")
  end

  scenario "grant access to authorized users" do
    login(email: "super@example.com")
    visit "/admin/cancancan"

    expect(page).to have_current_path("/admin/cancancan")
  end
end
