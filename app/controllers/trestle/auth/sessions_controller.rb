class Trestle::Auth::SessionsController < Trestle::ApplicationController
  layout 'trestle/auth'

  skip_before_action :require_authenticated_user

  def new
  end

  def create
    if user = Trestle.config.auth.authenticate(params)
      login!(user)
      remember_me! if Trestle.config.auth.remember.enabled && params[:remember_me] == "1"
      redirect_to previous_location || Trestle.config.path
    else
      flash[:error] = t("admin.auth.error", default: "Incorrect login details.")
      redirect_to action: :new
    end
  end

  def destroy
    logout!
    redirect_to login_url
  end
end
