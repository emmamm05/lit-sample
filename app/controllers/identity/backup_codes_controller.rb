class Identity::BackupCodesController < ApplicationController
  def index
    @user = Current.user
  end

  def create
    @user = Current.user
    @codes = @user.generate_backup_codes!
    render :show
  end
end
