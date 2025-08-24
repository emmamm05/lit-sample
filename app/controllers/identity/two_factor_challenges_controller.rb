class Identity::TwoFactorChallengesController < ApplicationController
  skip_before_action :authenticate, only: [:new, :create]

  def new
    @user = pre_two_fa_user
    redirect_to sign_in_path, alert: "Please sign in" and return unless @user
  end

  def create
    @user = pre_two_fa_user
    redirect_to sign_in_path, alert: "Please sign in" and return unless @user

    code = params[:code].to_s
    if @user.verify_totp(code) || @user.consume_backup_code!(code)
      session.delete(:pre_2fa_user_id)
      session_record = @user.sessions.create!
      cookies.signed.permanent[:session_token] = { value: session_record.id, httponly: true }
      redirect_to root_path, notice: "Signed in successfully"
    else
      flash.now[:alert] = "Invalid authentication code"
      render :new, status: :unprocessable_entity
    end
  end

  private
    def pre_two_fa_user
      uid = session[:pre_2fa_user_id]
      uid && User.find_by(id: uid)
    end
end
