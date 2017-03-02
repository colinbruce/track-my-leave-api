class ApplicationController < ActionController::API

  protected

  def authenticate_request!
    if !payload || !JsonWebToken.valid_payload(payload)
      return invalid_authentication
    end

    load_current_user!
    invalid_authentication unless @current_user
  end

  def invalid_authentication
    render json: { error: 'Invalid request', status: :unauthorized }
  end

  private

  def payload
    auth_header = request.headers['Authorization']
    token = auth_header.split(' ').last
    JsonWebToken.decode(token).first
  end

  def load_current_user!
    @current_user = User.find(payload['user_id'])
  end
end
