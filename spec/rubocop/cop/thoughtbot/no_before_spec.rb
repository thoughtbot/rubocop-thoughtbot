# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Thoughtbot::NoBefore, :config do
  it "registers an offense for before" do
    expect_offense(<<~RUBY)
      before { @user = build(:user) }
      ^^^^^^ Avoid `before` — set up test data inside each example so it doesn't become a mystery guest. See https://thoughtbot.com/blog/lets-not
    RUBY
  end

  it "registers an offense for a multiline before" do
    expect_offense(<<~RUBY)
      before do
      ^^^^^^ Avoid `before` — set up test data inside each example so it doesn't become a mystery guest. See https://thoughtbot.com/blog/lets-not
        @user = build(:user, name: "Amy")
      end
    RUBY
  end

  it "registers an offense for before with a scope" do
    expect_offense(<<~RUBY)
      before(:each) { @user = build(:user) }
      ^^^^^^ Avoid `before` — set up test data inside each example so it doesn't become a mystery guest. See https://thoughtbot.com/blog/lets-not
      before(:all) { @account = create(:account) }
      ^^^^^^ Avoid `before` — set up test data inside each example so it doesn't become a mystery guest. See https://thoughtbot.com/blog/lets-not
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

  it "accepts test data set up inside an example" do
    expect_no_offenses(<<~RUBY)
      it "is valid" do
        user = build(:user)

        expect(user).to be_valid
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

  it "accepts before sent to a receiver with safe navigation" do
    expect_no_offenses(<<~RUBY)
      config&.before { DatabaseCleaner.start }
    RUBY
  end

  it "accepts a local variable named before" do
    expect_no_offenses(<<~RUBY)
      before = "a value"

      expect(before).to eq("a value")
    RUBY
  end
end
