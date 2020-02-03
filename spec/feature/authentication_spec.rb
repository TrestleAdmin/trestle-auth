require "rails_helper"

feature "Authentication" do
  scenario "prevent unauthenticated access" do
    visit "/admin"
    expect(page.current_path).to eq("/admin/login")
  end
end
