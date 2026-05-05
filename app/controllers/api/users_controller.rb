module Api
  class UsersController < ApplicationController
    include Rails.application.routes.url_helpers
    before_action :require_admin_or_manager!
    before_action :set_user, only: [:show, :update, :destroy]

    def index
      @users = User.all
      render json: @users.map { |u| user_response(u) }
    end

    def show
      render json: user_response(@user)
    end

    def update
      requested_role = params.dig(:user, :role).to_s

      # Managers can assign editor or manager roles, but not admin
      if current_user.role.to_s == 'manager' && requested_role.present? && requested_role == 'admin'
        return render json: { error: 'Managers cannot assign the admin role' }, status: :forbidden
      end

      if params[:user][:email].present? && params[:user][:email] != @user.email
        return render json: { error: ["Email can't be updated"] }, status: :unprocessable_entity
      end

      if @user.update(user_update_params)
        @user.image.attach(params[:user][:image]) if params[:user][:image].present?
        render json: { user: user_response(@user) }, status: :ok
      else
        render json: { error: @user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      # Managers can only delete non-admin accounts
      if current_user.role.to_s == 'manager' && @user.role.to_s == 'admin'
        return render json: { error: 'Managers cannot delete admin accounts' }, status: :forbidden
      end

      @user.destroy!
      render json: { message: "User deleted successfully" }, status: :ok
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_update_params
      params.require(:user).permit(:name, :password, :password_confirmation, :image, :phone_number, :role)
    end

    def user_response(user)
      {
        id: user.id,
        name: user.name,
        email: user.email,
        role: user.role,
        image_url: user.image.attached? ? url_for(user.image) : nil
      }
    end
  end
end
