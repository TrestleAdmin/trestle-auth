# Trestle Authentication (trestle-auth)

[![RubyGem](https://img.shields.io/gem/v/trestle-auth?include_prereleases&color=%234d6bb2)](https://rubygems.org/gems/trestle-auth)
[![Build Status](https://img.shields.io/github/actions/workflow/status/TrestleAdmin/trestle-auth/rspec.yml?style=flat)](https://github.com/TrestleAdmin/trestle-auth/actions)
[![Coveralls](https://img.shields.io/coveralls/TrestleAdmin/trestle-auth.svg?style=flat)](https://coveralls.io/github/TrestleAdmin/trestle-auth)

> Authentication plugin for the Trestle admin framework

![Trestle-Auth-1](https://github.com/user-attachments/assets/d2a22188-0b1c-4ce9-8259-a63a260ba2e9)|![Trestle-Auth-2](https://github.com/user-attachments/assets/da780c58-1bb0-41a9-a4e3-1e23f4916654)
|:-:|:-:|


## Getting Started

These instructions assume you have a working Trestle application. See the [Getting Started](https://github.com/TrestleAdmin/trestle#getting-started) section in the Trestle README.

To integrate trestle-auth, first add it to your application's Gemfile, and then run `bundle install`:

```ruby
gem 'trestle-auth'
```

As of version 0.4.0, trestle-auth now supports multiple authentication backends including Devise/Warden.


### Option 1: Built-in Integration

Run the install generator to add the configuration to `config/initializers/trestle.rb`, and generate a `User` model and admin resource.

    $ rails generate trestle:auth:install User

(if no user model name is specified it will default to `Administrator`)

Then run your migrations with `rake db:migrate` and create an initial admin user from within `rails console`:

```ruby
User.create(email: "admin@example.com", password: "password", first_name: "Admin", last_name: "User")
```

After restarting your Rails server, any attempt to access a page within your admin will redirect you to the login page.


### Option 2: Devise Integration

If you already have an existing user model and Devise integration, you can configure trestle-auth to use that instead.

    $ rails generate trestle:auth:install User --devise

Replace `User` with the name of your Devise user model. If not specified, it will default to `Administrator`.


## Configuration

After running the `trestle:auth:install` generator, check your `config/initializers/trestle.rb` for further configuration options.


## License

The gem is available as open source under the terms of the [LGPLv3 License](https://opensource.org/licenses/LGPL-3.0).
