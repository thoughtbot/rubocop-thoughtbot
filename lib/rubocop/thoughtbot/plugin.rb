# frozen_string_literal: true

require "lint_roller"

module RuboCop
  module Thoughtbot
    class Plugin < LintRoller::Plugin
      def about
        LintRoller::About.new(
          name: "rubocop-thoughtbot",
          version: VERSION,
          homepage: "https://github.com/thoughtbot/rubocop-thoughtbot",
          description: "A RuboCop and Standard plugin based on thoughtbot's accumulated best-practices."
        )
      end

      def supported?(context)
        context.engine == :rubocop
      end

      def rules(_context)
        LintRoller::Rules.new(
          type: :path,
          config_format: :rubocop,
          value: Pathname.new(__dir__).join("../../../config/default.yml")
        )
      end
    end
  end
end
