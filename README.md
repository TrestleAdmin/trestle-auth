# Trestle Authentication (trestle-auth)

> Authentication plugin for the Trestle admin framework

<img src="https://trestle.io/images/Trestle-Auth-1.png" width="50%" /><img src="https://trestle.io/images/Trestle-Auth-2.png" width="50%" />


## Getting Started

These instructions assume you have a working Trestle application. To integrate trestle-auth, first add it to your application's Gemfile:

```ruby
gem 'trestle-auth'
```

Run `bundle install`, and then run the install generator to set up configuration options, user model and user admin resource.

    $ rails generate trestle:auth:install
    $ rake db:migrate

Then create an initial admin user from the rails console:

    $ rails console
    > Administrator.create(email: "admin@example.com", password: "password", first_name: "Admin", last_name: "User")

After restarting your Rails server, any attempt to access a page within your admin will redirect you to the login page.


## License

The gem is available as open source under the terms of the [LGPLv3 License](https://opensource.org/licenses/LGPL-3.0).
