# Trestle Authentication (trestle-auth)

[![RubyGem](https://img.shields.io/gem/v/trestle-auth.svg?style=flat&colorB=4065a9)](https://rubygems.org/gems/trestle-auth)
[![Travis](https://img.shields.io/travis/TrestleAdmin/trestle-auth.svg?style=flat)](https://travis-ci.org/TrestleAdmin/trestle-auth)
[![Coveralls](https://img.shields.io/coveralls/TrestleAdmin/trestle-auth.svg?style=flat)](https://coveralls.io/github/TrestleAdmin/trestle-auth)

> Authentication plugin for the Trestle admin framework

<img src="https://trestle.io/images/Trestle-Auth-1.png" width="50%" /><img src="https://trestle.io/images/Trestle-Auth-2.png" width="50%" />


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
