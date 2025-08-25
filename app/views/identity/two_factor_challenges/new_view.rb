# frozen_string_literal: true

module Identity
  module TwoFactorChallenges
    class NewView < ApplicationView
      def initialize
      end

      def view_template
        app_section do
          h1 { "Two‑factor authentication required" }
          p { "Enter a code from your authenticator app or a backup code." }

          helpers.form_with(url: helpers.identity_two_factor_challenge_path) do |f|
            div do
              plain f.label(:code, "Code")
              br
              plain f.text_field(:code, autofocus: true, autocomplete: "one-time-code")
            end
            div do
              plain f.submit("Verify")
            end
          end
        end
      end

      private

      def app_section(&)
        tag("app-section", &)
      end
    end
  end
end
