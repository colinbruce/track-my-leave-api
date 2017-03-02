class UsersController < ApplicationController
  require 'json_web_token'

  def create
    user = User.new(user_params)

    if user.save
      # TODO: send email with confirmation_token
      render json: { status: 'User created successfully' }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :bad_request
    end
  end

  def confirm
    token = params[:token].to_s

    user = User.find_by(confirmation_token: token)

    if user&.confirmation_token_valid?
      user.mark_as_confirmed!
      render json: { status: 'User successfully confirmed' }, status: :ok
    else
      render json: { status: 'Invalid token' }, status: :not_found
    end
  end

  def login
    if login_successful?
      auth_token = JsonWebToken.encode(user_id: login_user.id)
      render json: { auth_token: auth_token }, status: :ok
    elsif user_unconfirmed?
      render json: { error: 'Email not verified' }, status: :unauthorized
    else
      render json: { error: 'Invalid username / password' }, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def login_user
    @login_user ||= User.find_by(email: params[:email].to_s.downcase)
  end

  def login_successful?
    user_exists_and_password_matches && login_user.confirmed_at?
  end

  def user_unconfirmed?
    user_exists_and_password_matches && login_user.unconfirmed?
  end

  def user_exists_and_password_matches
    login_user && login_user.authenticate(params[:password])
  end
end
