class CustomController < ApplicationController
  def index
    render plain: "Hello from custom controller"
  end
end
