Rails.application.routes.draw do
  devise_for :devise_users, skip: :all
end

Trestle::Engine.routes.draw do
  get "/custom", to: "custom#index", constraints: Trestle::Auth::Constraint.new
end
