# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Thoughtbot::NoLet, :config do
  it "registers an offense for let" do
    expect_offense(<<~RUBY)
      let(:user) { build(:user) }
      ^^^ Avoid `let` — set up test data inside each example so it doesn't become a mystery guest. See https://thoughtbot.com/blog/lets-not
    RUBY
  end

  it "registers an offense for let!" do
    expect_offense(<<~RUBY)
      let!(:user) { create(:user) }
      ^^^^ Avoid `let!` — set up test data inside each example so it doesn't become a mystery guest. See https://thoughtbot.com/blog/lets-not
    RUBY
  end

  it "registers an offense for a multiline let" do
    expect_offense(<<~RUBY)
      let(:user) do
      ^^^ Avoid `let` — set up test data inside each example so it doesn't become a mystery guest. See https://thoughtbot.com/blog/lets-not
        build(:user, name: "Amy")
      end
    RUBY
  end

  it "registers an offense for each let in a group" do
    expect_offense(<<~RUBY)
      RSpec.describe User do
        let(:user) { build(:user) }
        ^^^ Avoid `let` — set up test data inside each example so it doesn't become a mystery guest. See https://thoughtbot.com/blog/lets-not
        let(:account) { build(:account) }
        ^^^ Avoid `let` — set up test data inside each example so it doesn't become a mystery guest. See https://thoughtbot.com/blog/lets-not
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

  it "accepts let sent to a receiver" do
    expect_no_offenses(<<~RUBY)
      config.let(:key) { value }
    RUBY
  end

  it "accepts let sent to a receiver with safe navigation" do
    expect_no_offenses(<<~RUBY)
      config&.let(:key) { value }
    RUBY
  end

  it "accepts a local variable named let" do
    expect_no_offenses(<<~RUBY)
      let = "a value"

      expect(let).to eq("a value")
    RUBY
  end
end
