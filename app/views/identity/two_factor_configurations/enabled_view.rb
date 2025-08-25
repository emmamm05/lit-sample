# frozen_string_literal: true

module Identity
  module TwoFactorConfigurations
    class EnabledView < ApplicationView
      def initialize(codes: [])
        @codes = codes
      end

      def view_template
        app_section do
          h1 { "Two‑factor enabled" }
          p { "Save these backup codes in a safe place. Each code can be used once if you lose access to your authenticator." }

          div(id: "backup-codes", data: { download_filename: "backup-codes.txt" }) do
            ul do
              @codes.each do |code_value|
                li { code { code_value } }
              end
            end
          end

          div(style: "margin-top: 1em;") do
            button(type: "button", id: "copy-codes") { "Copy to clipboard" }
            text " "
            button(type: "button", id: "download-codes") { "Download" }
          end

          p(style: "margin-top: 1em;") do
            plain helpers.link_to("Done", helpers.root_path)
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
