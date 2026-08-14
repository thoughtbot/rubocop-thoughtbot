# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Thoughtbot::NoBefore, :config do
  it "registers an offense for before" do
    expect_offense(<<~RUBY)
      RSpec.describe User do
        before { @user = build(:user) }
        ^^^^^^ Avoid `before` — set up test data inside each example so it doesn't become a mystery guest. See https://thoughtbot.com/blog/lets-not
      end
    RUBY
  end

  it "registers an offense for a multiline before" do
    expect_offense(<<~RUBY)
      RSpec.describe User do
        before do
        ^^^^^^ Avoid `before` — set up test data inside each example so it doesn't become a mystery guest. See https://thoughtbot.com/blog/lets-not
          @user = build(:user, name: "Amy")
        end
      end
    RUBY
  end

  it "registers an offense for before with a scope" do
    expect_offense(<<~RUBY)
      RSpec.describe User do
        before(:each) { @user = build(:user) }
        ^^^^^^ Avoid `before` — set up test data inside each example so it doesn't become a mystery guest. See https://thoughtbot.com/blog/lets-not
        before(:all) { @account = create(:account) }
        ^^^^^^ Avoid `before` — set up test data inside each example so it doesn't become a mystery guest. See https://thoughtbot.com/blog/lets-not
      end
    RUBY
  end

  it "registers an offense for each before in a group" do
    expect_offense(<<~RUBY)
      RSpec.describe User do
        before { @user = build(:user) }
        ^^^^^^ Avoid `before` — set up test data inside each example so it doesn't become a mystery guest. See https://thoughtbot.com/blog/lets-not

        context "with an account" do
          before { @account = build(:account) }
          ^^^^^^ Avoid `before` — set up test data inside each example so it doesn't become a mystery guest. See https://thoughtbot.com/blog/lets-not
        end
      end
    RUBY
  end

  it "registers an offense for before in a describe without an RSpec receiver" do
    expect_offense(<<~RUBY)
      describe Article do
        context "validations" do
          before { @article = build(:article) }
          ^^^^^^ Avoid `before` — set up test data inside each example so it doesn't become a mystery guest. See https://thoughtbot.com/blog/lets-not
        end
      end
    RUBY
  end

  it "registers an offense for before in a shared group" do
    expect_offense(<<~RUBY)
      RSpec.shared_examples "a record" do
        before { @user = build(:user) }
        ^^^^^^ Avoid `before` — set up test data inside each example so it doesn't become a mystery guest. See https://thoughtbot.com/blog/lets-not
      end
    RUBY
  end

  it "registers an offense for before in a feature group" do
    expect_offense(<<~RUBY)
      feature "Signing in" do
        before { @user = build(:user) }
        ^^^^^^ Avoid `before` — set up test data inside each example so it doesn't become a mystery guest. See https://thoughtbot.com/blog/lets-not
      end
    RUBY
  end

  it "registers an offense for before set up in a class method of a group" do
    expect_offense(<<~RUBY)
      RSpec.describe User do
        def self.with_an_account
          before { @account = build(:account) }
          ^^^^^^ Avoid `before` — set up test data inside each example so it doesn't become a mystery guest. See https://thoughtbot.com/blog/lets-not
        end
      end
    RUBY
  end

  it "registers an offense for before in a module that extends RSpec::SharedContext" do
    expect_offense(<<~RUBY)
      module SignedIn
        extend RSpec::SharedContext

        before { @user = build(:user) }
        ^^^^^^ Avoid `before` — set up test data inside each example so it doesn't become a mystery guest. See https://thoughtbot.com/blog/lets-not
      end
    RUBY
  end

  it "accepts test data set up inside an example" do
    expect_no_offenses(<<~RUBY)
      RSpec.describe User do
        it "is valid" do
          user = build(:user)

          expect(user).to be_valid
        end
      end
    RUBY
  end

  it "accepts before sent to a receiver" do
    expect_no_offenses(<<~RUBY)
      RSpec.configure do |config|
        config.before { DatabaseCleaner.start }
      end
    RUBY
  end

  it "accepts a local variable named before" do
    expect_no_offenses(<<~RUBY)
      RSpec.describe User do
        before = "a value"

        expect(before).to eq("a value")
      end
    RUBY
  end

  it "accepts before in a class body" do
    expect_no_offenses(<<~RUBY)
      class FakeHub < Sinatra::Base
        before do
          content_type "application/json"
        end
      end
    RUBY
  end

  it "accepts before in a class body nested in an example group" do
    expect_no_offenses(<<~RUBY)
      RSpec.describe FakeHub do
        class FakeHub < Sinatra::Base
          before { content_type "application/json" }
        end
      end
    RUBY
  end

  it "accepts before in a module body" do
    expect_no_offenses(<<~RUBY)
      module Authentication
        before { authenticate! }
      end
    RUBY
  end

  it "accepts before in a fake app built inside an example group" do
    expect_no_offenses(<<~RUBY)
      RSpec.describe Middleware do
        let(:app) do
          Sinatra.new do
            before { content_type "application/json" }
          end
        end
      end
    RUBY
  end

  # A mystery guest the cop misses, because it asks for a group around the
  # hook directly rather than searching upwards for one. Searching upwards
  # would reach the group around a fake app built inside a group too, and
  # flagging Sinatra's `before` is the worse of the two mistakes: a false
  # positive has to be silenced by hand, while this shape is rare.
  it "accepts before in a loop nested in an example group" do
    expect_no_offenses(<<~RUBY)
      RSpec.describe Report do
        %i[csv pdf].each do |format|
          before { @report = build(:report, format: format) }
        end
      end
    RUBY
  end

  # A `before` outside any example group raises `NoMethodError: undefined
  # method 'before' for main` when RSpec loads the file, so there is no
  # mystery guest to warn about — the file never runs.
  it "accepts before outside an example group" do
    expect_no_offenses(<<~RUBY)
      before { @user = build(:user) }
    RUBY
  end

  it "registers an offense for before in an example group beside a class body" do
    expect_offense(<<~RUBY)
      class FakeHub < Sinatra::Base
        before { content_type "application/json" }
      end

      RSpec.describe FakeHub do
        before { @user = build(:user) }
        ^^^^^^ Avoid `before` — set up test data inside each example so it doesn't become a mystery guest. See https://thoughtbot.com/blog/lets-not
      end
    RUBY
  end
end
