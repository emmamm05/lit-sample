# frozen_string_literal: true

module Identity
  module BackupCodes
    class ShowView < ApplicationView
      def initialize(codes: [])
        @codes = codes
      end

      def view_template
        h1 { "Your new backup codes" }
        p { "Store these codes securely. Each code can be used once." }

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
          plain helpers.link_to("Back", helpers.identity_backup_codes_path)
        end
      end
    end
  end
end
