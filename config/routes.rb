Trestle::Engine.routes.draw do
  controller "trestle/auth/sessions" do
    if Trestle.config.auth.enable_login
      get  'login'  => :new, as: :login
      post 'login'  => :create
    end

    if Trestle.config.auth.enable_logout
      get 'logout' => :destroy, as: :logout
    end
  end
end
