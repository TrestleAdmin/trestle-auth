class Trestle::Auth::SessionsController < Trestle::ApplicationController
  layout 'trestle/auth'

  skip_before_action :authenticate_user, only: [:new, :create]
  skip_before_action :require_authenticated_user

  def new
  end

  def create
    if authentication_backend.authenticate!
      redirect_to authentication_backend.previous_location || instance_exec(&Trestle.config.auth.redirect_on_login)
    else
      flash[:error] = t("admin.auth.error", default: "Incorrect login details.")
      redirect_to action: :new
    end
  end

  def destroy
    logout!
    redirect_to instance_exec(&Trestle.config.auth.redirect_on_logout)
  end
end
