# frozen_string_literal: true

module RuboCop
  module Cop
    module Thoughtbot
      # Checks for public methods in Rails controllers outside the seven
      # resourceful actions: `index`, `show`, `new`, `edit`, `create`,
      # `update` and `destroy`.
      #
      # A custom action needs a custom route, and custom routes pick their
      # verbs ad hoc (`update-password`, `add-payment-method`, `activate`)
      # so no two read the same way. Sticking to the seven constrains you to
      # the standard HTTP verbs and pushes the naming into nouns, which are
      # far less ambiguous than invented verbs. It also keeps controllers
      # small, since the fix for a new action is a new controller.
      #
      # Rails routes any public instance method on a controller, so this cop
      # also flags helpers left public. Those should be private.
      #
      # Controllers dictated by a gem (`Devise::OmniauthCallbacksController`
      # with an action per provider, or Doorkeeper's OAuth endpoints) can't
      # follow the convention. Exclude them:
      #
      #   Thoughtbot/ResourcefulActions:
      #     Exclude:
      #       - "app/controllers/users/omniauth_callbacks_controller.rb"
      #
      # See https://thoughtbot.com/blog/in-relentless-pursuit-of-rest-ish-routing
      #
      # @example
      #   # bad
      #   class UsersController < ApplicationController
      #     def activate
      #     end
      #   end
      #
      #   # good
      #   class Users::ActivationsController < ApplicationController
      #     def create
      #     end
      #   end
      #
      #   # bad
      #   class ApplicationController < ActionController::Base
      #     def current_user
      #     end
      #   end
      #
      #   # good
      #   class ApplicationController < ActionController::Base
      #     private
      #
      #     def current_user
      #     end
      #   end
      #
      class ResourcefulActions < Base
        MSG = "`%<name>s` is not one of the seven resourceful actions (index, " \
              "show, new, edit, create, update, destroy) — rename it, extract " \
              "another controller, or make it private if it isn't an action. " \
              "See https://thoughtbot.com/blog/in-relentless-pursuit-of-rest-ish-routing"

        RESOURCEFUL_ACTIONS = %i[index show new edit create update destroy].freeze
        VISIBILITY_MODIFIERS = %i[public protected private].freeze

        def on_class(node)
          return unless controller?(node)
          return unless node.body

          non_resourceful_actions(node.body).each do |action|
            add_offense(action.loc.name, message: format(MSG, name: action.method_name))
          end
        end

        private

        def controller?(node)
          node.identifier.short_name.to_s.end_with?("Controller")
        end

        def non_resourceful_actions(body)
          visibility = :public
          public_defs = []
          hidden = []

          body_children(body).each do |child|
            if visibility_modifier?(child)
              child.arguments.empty? ? visibility = child.method_name : hidden.concat(hidden_names(child))
            elsif child.def_type? && visibility == :public
              public_defs << child
            end
          end

          public_defs.reject do |definition|
            RESOURCEFUL_ACTIONS.include?(definition.method_name) || hidden.include?(definition.method_name)
          end
        end

        def body_children(body)
          body.begin_type? ? body.children : [body]
        end

        def visibility_modifier?(node)
          node.send_type? && node.receiver.nil? && VISIBILITY_MODIFIERS.include?(node.method_name)
        end

        # `private :current_user` hides an already-defined method. An inline
        # `private def foo` passes a `def` rather than a symbol, and never
        # reaches us as a body child anyway.
        def hidden_names(node)
          return [] if node.method?(:public)

          node.arguments.select(&:sym_type?).map(&:value)
        end
      end
    end
  end
end
