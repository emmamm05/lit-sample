require "test_helper"

class TwoFactorAuthenticationTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:lazaro_nixon)
  end

  test "enable two factor and generate backup codes" do
    sign_in_as @user

    get new_identity_two_factor_configuration_url
    assert_response :success

    # QR should be present on the page
    assert_select "svg"

    # prepare secret exists
    @user.reload
    assert @user.otp_secret.present?

    totp = ROTP::TOTP.new(@user.otp_secret, issuer: Rails.application.class.module_parent_name)

    post identity_two_factor_configuration_url, params: { code: totp.now }
    assert_response :success
    assert_select "h1", /Two‑factor enabled/
    # Should offer copy and download controls
    assert_select "#copy-codes"
    assert_select "#download-codes"

    @user.reload
    assert @user.otp_enabled?
    assert @user.otp_backup_codes.present?
  end

  test "sign in requires two factor and succeeds with totp" do
    # Enable 2FA first
    sign_in_as @user
    get new_identity_two_factor_configuration_url
    @user.reload
    totp = ROTP::TOTP.new(@user.otp_secret, issuer: Rails.application.class.module_parent_name)
    post identity_two_factor_configuration_url, params: { code: totp.now }
    delete session_url(@user.sessions.last) # sign out to test sign-in flow

    # Now try sign-in, should be redirected to 2FA challenge
    post sign_in_url, params: { email: @user.email, password: "Secret1*3*5*" }
    assert_redirected_to new_identity_two_factor_challenge_url

    get new_identity_two_factor_challenge_url
    assert_response :success

    post identity_two_factor_challenge_url, params: { code: ROTP::TOTP.new(@user.reload.otp_secret).now }
    assert_redirected_to root_url
  end

  test "sign in with backup code consumes it" do
    sign_in_as @user
    get new_identity_two_factor_configuration_url
    @user.reload
    post identity_two_factor_configuration_url, params: { code: ROTP::TOTP.new(@user.otp_secret).now }

    # Generate explicit new codes and capture one
    post identity_backup_codes_url
    assert_response :success
    # Should offer copy and download controls
    assert_select "#copy-codes"
    assert_select "#download-codes"

    code = @response.body[/<code>([^<]+)<\/code>/, 1]
    assert code.present?

    # Sign out and sign in using backup code
    delete session_url(@user.sessions.last)

    post sign_in_url, params: { email: @user.email, password: "Secret1*3*5*" }
    assert_redirected_to new_identity_two_factor_challenge_url
    post identity_two_factor_challenge_url, params: { code: code }
    assert_redirected_to root_url

    # Code should be consumed
    remaining = JSON.parse(@user.reload.otp_backup_codes).size
    assert remaining < 10
  end
end
