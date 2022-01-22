module Trestle
  module Auth
    # Trestle::Auth::Constraint is a Rails routing constraint that can be used to protect
    # segments of your application that aren't regular Trestle admins or resources
    # (all of which are automatically protected).
    #
    # Note that when using a Rails routing constraint like this one, any unauthenticated
    # requests will return a 404 (Not Found) rather than a redirect to the login page.
    #
    # Examples
    #
    #   mount Sidekiq::Web => "/sidekiq/web", constraints: Trestle::Auth::Constraint.new
    #
    #   constraints Trestle::Auth::Constraint.new do
    #     get "/custom/action", to 'custom#action'
    #   end
    #
    class Constraint
      def matches?(request)
        backend = authentication_backend_for(request)
        backend.authenticate
        backend.logged_in?
      end

    private
      def authentication_backend_for(request)
        Trestle.config.auth.backend.new(controller: self, request: request, session: request.session, cookies: request.cookie_jar)
      end
    end
  end
end
