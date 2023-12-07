class Users::PasswordResetsController < ApplicationController
  skip_authentication

  def new
  end

  def create
    User.find_by(email: params[:email])&.reset_password
  end
end
