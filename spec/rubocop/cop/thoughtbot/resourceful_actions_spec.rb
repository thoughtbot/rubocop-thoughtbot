# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Thoughtbot::ResourcefulActions, :config do
  it "registers an offense for a non-resourceful action" do
    expect_offense(<<~RUBY)
      class UsersController < ApplicationController
        def activate
            ^^^^^^^^ `activate` is not one of the seven resourceful actions (index, show, new, edit, create, update, destroy) — rename it, extract another controller, or make it private if it isn't an action. See https://thoughtbot.com/blog/in-relentless-pursuit-of-rest-ish-routing
        end
      end
    RUBY
  end

  it "registers an offense for each non-resourceful action" do
    expect_offense(<<~RUBY)
      class UsersController < ApplicationController
        def activate
            ^^^^^^^^ `activate` is not one of the seven resourceful actions (index, show, new, edit, create, update, destroy) — rename it, extract another controller, or make it private if it isn't an action. See https://thoughtbot.com/blog/in-relentless-pursuit-of-rest-ish-routing
        end

        def edit_password
            ^^^^^^^^^^^^^ `edit_password` is not one of the seven resourceful actions (index, show, new, edit, create, update, destroy) — rename it, extract another controller, or make it private if it isn't an action. See https://thoughtbot.com/blog/in-relentless-pursuit-of-rest-ish-routing
        end
      end
    RUBY
  end

  it "registers an offense for a public method that isn't an action at all" do
    expect_offense(<<~RUBY)
      class ApplicationController < ActionController::Base
        def current_user
            ^^^^^^^^^^^^ `current_user` is not one of the seven resourceful actions (index, show, new, edit, create, update, destroy) — rename it, extract another controller, or make it private if it isn't an action. See https://thoughtbot.com/blog/in-relentless-pursuit-of-rest-ish-routing
          @current_user ||= User.find_by(id: session[:user_id])
        end
        helper_method :current_user
      end
    RUBY
  end

  it "registers an offense for an action made public again after private" do
    expect_offense(<<~RUBY)
      class UsersController < ApplicationController
        private

        def user_params
        end

        public

        def activate
            ^^^^^^^^ `activate` is not one of the seven resourceful actions (index, show, new, edit, create, update, destroy) — rename it, extract another controller, or make it private if it isn't an action. See https://thoughtbot.com/blog/in-relentless-pursuit-of-rest-ish-routing
        end
      end
    RUBY
  end

  it "registers an offense for a controller nested in a module" do
    expect_offense(<<~RUBY)
      module Admin
        class UsersController < ApplicationController
          def activate
              ^^^^^^^^ `activate` is not one of the seven resourceful actions (index, show, new, edit, create, update, destroy) — rename it, extract another controller, or make it private if it isn't an action. See https://thoughtbot.com/blog/in-relentless-pursuit-of-rest-ish-routing
          end
        end
      end
    RUBY
  end

  it "accepts the seven resourceful actions" do
    expect_no_offenses(<<~RUBY)
      class UsersController < ApplicationController
        def index
        end

        def show
        end

        def new
        end

        def edit
        end

        def create
        end

        def update
        end

        def destroy
        end
      end
    RUBY
  end

  it "accepts methods below private" do
    expect_no_offenses(<<~RUBY)
      class UsersController < ApplicationController
        def show
        end

        private

        def user_params
        end

        def authorize_user
        end
      end
    RUBY
  end

  it "accepts methods below protected" do
    expect_no_offenses(<<~RUBY)
      class UsersController < ApplicationController
        protected

        def current_user
        end
      end
    RUBY
  end

  it "accepts an inline private def" do
    expect_no_offenses(<<~RUBY)
      class UsersController < ApplicationController
        private def user_params
        end
      end
    RUBY
  end

  it "accepts a method made private by name" do
    expect_no_offenses(<<~RUBY)
      class UsersController < ApplicationController
        def current_user
        end
        private :current_user
      end
    RUBY
  end

  it "accepts class methods" do
    expect_no_offenses(<<~RUBY)
      class UsersController < ApplicationController
        def self.activate
        end
      end
    RUBY
  end

  it "accepts a class that isn't a controller" do
    expect_no_offenses(<<~RUBY)
      class UserActivator
        def activate
        end
      end
    RUBY
  end

  it "accepts a concern" do
    expect_no_offenses(<<~RUBY)
      module Authentication
        extend ActiveSupport::Concern

        def activate
        end
      end
    RUBY
  end
end
