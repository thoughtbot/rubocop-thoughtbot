# frozen_string_literal: true

module RuboCop
  module Cop
    module Thoughtbot
      # Common functionality for cops that flag a bare RSpec DSL call.
      #
      # A spec directory holds more than specs. A fake Sinatra or Grape app
      # under `spec/support` defines a `before` of its own, so a cop that
      # matches on the method name alone flags code that has nothing to do
      # with RSpec. Asking where the call sits keeps the cop to RSpec's DSL.
      module SpecGroup
        extend RuboCop::AST::NodePattern::Macros

        SCOPES = %i[block numblock itblock class module].freeze

        # Matches rubocop-rspec's `ExampleGroups` and `SharedGroups`.
        SPEC_GROUPS = %i[
          describe context feature example_group
          xdescribe xcontext xfeature
          fdescribe fcontext ffeature
          shared_examples shared_examples_for shared_context
        ].freeze

        # @!method spec_group?(node)
        def_node_matcher :spec_group?, <<~PATTERN
          (any_block
            (send {nil? (const {nil? cbase} :RSpec)} #spec_group_name? ...) ...)
        PATTERN

        # @!method extends_shared_context?(node)
        def_node_matcher :extends_shared_context?, <<~PATTERN
          (send nil? :extend (const (const {nil? cbase} :RSpec) :SharedContext))
        PATTERN

        private

        def inside_spec_group?(node)
          scope = enclosing_scope(node)

          spec_group?(scope) || shared_context_module?(scope)
        end

        def spec_group_name?(name)
          SPEC_GROUPS.include?(name)
        end

        def shared_context_module?(node)
          return false unless node&.module_type?

          body_statements(node).any? { |statement| extends_shared_context?(statement) }
        end

        def body_statements(node)
          body = node.body

          if body.nil?
            []
          elsif body.begin_type?
            body.children
          else
            [body]
          end
        end

        def enclosing_scope(node)
          call = node.block_node || node

          call.each_ancestor(*SCOPES).first
        end
      end
    end
  end
end
