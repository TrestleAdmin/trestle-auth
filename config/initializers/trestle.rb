Trestle.configure do |config|
  config.hook("stylesheets") do
    stylesheet_link_tag("trestle/auth/userbox")
  end

  config.hook("view.header") do
    render "trestle/auth/userbox"
  end
end
