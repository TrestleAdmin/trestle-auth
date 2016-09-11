Trestle::Engine.routes.draw do
  controller "trestle/auth/sessions" do
    get  'login'  => :new, as: :login
    post 'login'  => :create
    get  'logout' => :destroy, as: :logout
  end
end
