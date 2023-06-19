# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    # super
    @user = User.where("email = ?", params["user"]["email"]).first
    if @user.present? && @user.valid_password?(params["user"]["password"])
      if @user.two_factor
        otp = SecureRandom.random_number(999999)
        @user.update_columns(otp: otp, valid_till: DateTime.now + 5.minutes)
        OtpMailer.send_otp(@user, otp).deliver_now
        redirect_to otp_page_path(user: @user)
      else
        sign_in @user
        redirect_to user_path(@user)
      end
    else
      flash[:alert] = "Incorrect email/password."
      redirect_to new_session_path(resource_name)
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
