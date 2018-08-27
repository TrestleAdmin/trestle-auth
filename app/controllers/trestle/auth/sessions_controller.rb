class Trestle::Auth::SessionsController < Trestle::ApplicationController
  layout 'trestle/auth'

  skip_before_action :require_authenticated_user

  def new
  end

  def create
    if user = Trestle.config.auth.authenticate(params)
      login!(user)
      remember_me! if params[:remember_me] == "1"
      redirect_to previous_location || instance_exec(&Trestle.config.auth.redirect_on_login)
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
