class PasswordResetsController < ApplicationController
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)

    if @user
      send_password_reset_email_for(@user)
      flash[:info] = 'Email sent with password reset instructions'
      redirect_to root_url
    else
      flash.now[:danger] = 'Email address not found'
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      @errors = @user.errors
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = 'Password has been reset.'
      redirect_to @user
    else
      @errors = @user.errors	    
      render 'edit'
    end
  end

  private
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def send_password_reset_email_for(user)
      user.create_reset_digest
      UserMailer.password_reset(user).deliver_now
    end

    def valid_user
      @user = User.find_by(email: params[:email])

      if (@user.nil? || !@user.activated? || !@user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end	
    end

    def check_expiration
      if @user.password_reset_expired?
	flash[:danger] = 'Password reset has expired.'
	redirect_to new_password_reset_url
      end
    end
end
