# frozen_string_literal: true

module RuboCop
  module Cop
    module Thoughtbot
      # Checks for `before` hooks in specs.
      #
      # Setup in a `before` sits away from the examples that use it, so a
      # reader has to jump around the file to work out what any one example is
      # actually doing (the `before` becomes a mystery guest). Setting data up
      # inside each example keeps the whole story of the test in one place,
      # avoids messy overrides for differing scenarios, and keeps the cost of
      # setup visible.
      #
      # See https://thoughtbot.com/blog/lets-not
      #
      # See https://thoughtbot.com/blog/the-arrange-act-assert-pattern
      #
      # @example
      #   # bad
      #   RSpec.describe User do
      #     before { @user = build(:user) }
      #
      #     it "is valid" do
      #       expect(@user).to be_valid
      #     end
      #   end
      #
      #   # good
      #   RSpec.describe User do
      #     it "is valid" do
      #       user = build(:user)
      #
      #       expect(user).to be_valid
      #     end
      #   end
      #
      class NoBefore < Base
        include SpecGroup

        MSG = "Avoid `before` — set up test data inside each example so it " \
              "doesn't become a mystery guest. See https://thoughtbot.com/blog/lets-not"

        RESTRICT_ON_SEND = %i[before].freeze

        def on_send(node)
          return if node.receiver
          return unless inside_spec_group?(node)

          add_offense(node.loc.selector)
        end
        alias_method :on_csend, :on_send
      end
    end
  end
end
