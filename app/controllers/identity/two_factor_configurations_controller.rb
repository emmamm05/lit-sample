class Identity::TwoFactorConfigurationsController < ApplicationController
  def new
    @user = Current.user
    unless @user.otp_enabled?
      @user.update!(otp_secret: ROTP::Base32.random_base32) if @user.otp_secret.blank?
      # Build provisioning URI for QR (otpauth://)
      @provisioning_uri = ROTP::TOTP.new(@user.otp_secret, issuer: Rails.application.class.module_parent_name).provisioning_uri(@user.email)
    end
  end

  def create
    @user = Current.user
    unless @user.otp_secret.present?
      redirect_to new_identity_two_factor_configuration_path, alert: "Secret not prepared" and return
    end

    code = params[:code].to_s
    if ROTP::TOTP.new(@user.otp_secret, issuer: Rails.application.class.module_parent_name).verify(code, drift_ahead: 30, drift_behind: 30)
      @user.update!(otp_enabled_at: Time.current)
      @codes = @user.generate_backup_codes!
      render :enabled
    else
      flash.now[:alert] = "Invalid code"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    Current.user.disable_otp!
    redirect_to root_path, notice: "Two-factor authentication disabled"
  end
end
