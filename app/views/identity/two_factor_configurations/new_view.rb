# frozen_string_literal: true

module Identity
  module TwoFactorConfigurations
    class NewView < ApplicationView
      def initialize(user:, provisioning_uri: nil)
        @user = user
        @provisioning_uri = provisioning_uri
      end

      def view_template
        app_section do
          h1 { "Enable two‑factor authentication" }

          if @user.otp_enabled?
            p { "Two‑factor authentication is already enabled." }
            plain helpers.button_to("Disable two‑factor authentication", helpers.identity_two_factor_configuration_path, method: :delete)
          else
            p { "Scan this QR in your authenticator app (Google Authenticator, 1Password, Authy, etc.) or enter the secret manually, then submit a code to confirm." }

            if defined?(RQRCode) && @provisioning_uri.present?
              qrcode = RQRCode::QRCode.new(@provisioning_uri)
              div(aria_label: "TOTP QR Code") do
                # RQRCode generates raw SVG markup
                unsafe_raw qrcode.as_svg(module_size: 6, standalone: true)
              end
            end

            p do
              strong { "Secret:" }
              text " "
              code { @user.otp_secret.to_s }
            end

            helpers.form_with(url: helpers.identity_two_factor_configuration_path) do |f|
              div do
                plain f.label(:code, "Authentication code")
                br
                plain f.text_field(:code, autocomplete: "one-time-code")
              end
              div do
                plain f.submit("Enable")
              end
            end
          end
        end
      end

      private

      def app_section(&)
        # preserve <app-section> wrapper used by layout/content
        tag("app-section", &)
      end
    end
  end
end
