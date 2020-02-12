Rails.application.routes.draw do
  devise_for :devise_users, skip: :all
end
