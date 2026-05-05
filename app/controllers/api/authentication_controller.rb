module Api
  class AuthenticationController < ApplicationController
    include Rails.application.routes.url_helpers
    skip_before_action :authorize_request, only: [:login]
    before_action :require_admin_or_manager!, only: [:signup]

    def signup
      requested_role = params.dig(:user, :role).to_s

      # Managers can create editors and managers, but not admins
      if current_user.role.to_s == 'manager' && requested_role == 'admin'
        return render json: { error: 'Managers cannot create admin users' }, status: :forbidden
      end

      user = User.new(user_params)
      if user.save
        user.image.attach(params[:user][:image]) if params[:user][:image].present?
        render json: { user: user_response(user) }, status: :created
      else
        render json: { error: user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def login
      user = User.find_by(email: params[:email])
      if user && user.authenticate(params[:password])
        token = encode_token(user.id)
        render json: { user: user_response(user), token: token }, status: :ok
      else
        render json: { error: 'Invalid credentials' }, status: :unauthorized
      end
    end

    private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :image, :phone_number, :role)
    end

    def encode_token(user_id)
      payload = { user_id: user_id, exp: 24.hours.from_now.to_i }
      JWT.encode(payload, Rails.application.secret_key_base, 'HS256')
    end

    def user_response(user)
      {
        id: user.id,
        name: user.name,
        email: user.email,
        image_url: user.image.attached? ? url_for(user.image) : nil
      }
    end
  end
end
