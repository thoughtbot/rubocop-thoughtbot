# RuboCop::Thoughtbot

A [RuboCop] and [Standard] plugin based on thoughtbot's accumulated best-practices.

[RuboCop]: https://rubocop.org
[Standard]: https://github.com/standardrb/standard

## Why?

We believe there is more that linting can solve. And it's not just style debates
about quotes or spaces.

- The mystery guest `let` that lives 150 lines from the spec example, causing
  [confusion and hours lost debugging]
- The controller that grows an `activate` action, then a `publish`, until
  [nothing about the file is predictable]

These are patterns we see repeated from human developers and AIs alike. For humans,
we solve this during code review, but slowly, inconsistently, and one developer
at a time. For AI, we put [guidance] into `CLAUDE.md` or `AGENTS.md`. But steering
an LLM is probabilistic, whereas a linter is deterministic. Linters let us move the
feedback loop left, into the developer's editor and into the [agent's hooks]. That's
what guides a codebase towards good practices and good architecture (the things that
keep it clean and easy to maintain in 2 years time).

A faster loop only helps if the feedback teaches. The person reading a message may
be meeting the convention for the first time, and it may be the only documentation
they ever read. A message that assumes the convention is already understood only
helps the people who didn't need it. So each cop carries its argument with it: the
message names what's wrong, says what to do about it, and links the reasoning.

[confusion and hours lost debugging]: https://thoughtbot.com/blog/lets-not
[nothing about the file is predictable]: https://thoughtbot.com/blog/in-relentless-pursuit-of-rest-ish-routing
[guidance]: https://github.com/thoughtbot/guides/tree/main/rails/ai-rules
[agent's hooks]: https://thoughtbot.com/blog/enforcing-your-ruby-style-guide-on-ai-generated-code

## What to expect

These cops are our opinions on clean code and maintainable software. The intention
is for you to layer these on top of Standard, or your own RuboCop config.

In time, we might be able to upstream some of them, but we're releasing a separate
Gem to give us the freedom to rapidly experiment and iterate across a wide range of
codebases first.

Linting works great for things that are deterministic, but there are plenty of best
practices where "it depends". Where a rule is _generally_ true we think the linting
guidance outweighs the occasional false positive (and you can exclude the files where
it genuinely doesn't apply). We won't always get this right, and a cop that turns out
to be more trouble than it's worth will be removed.

## Installation

This gem is not published to RubyGems yet, so install it from GitHub. Add it to
your Gemfile:

```ruby
group :development, :test do
  gem "rubocop-thoughtbot", github: "thoughtbot/rubocop-thoughtbot", require: false
  # Or via SSH while the repo is private
  # gem "rubocop-thoughtbot", git: "git@github.com:thoughtbot/rubocop-thoughtbot.git", require: false
end
```

Then run `bundle install`.

Next, tell your linter to load the plugin.

### RuboCop

In `.rubocop.yml`:

```yaml
plugins:
  - rubocop-thoughtbot
```

### Standard

In `.standard.yml`:

```yaml
plugins:
  - rubocop-thoughtbot
```

## Usage

Run your linter as usual and the cops are applied:

```bash
bundle exec rubocop
# or
bundle exec standardrb
```

## Show me the cops!

All cops are located under [`lib/rubocop/cop/thoughtbot`](lib/rubocop/cop/thoughtbot),
or you can [view the docs](docs/modules/ROOT/pages/cops_thoughtbot.adoc).

### Excluding files

Each cop is a single opinion and doesn't take options (the knobs it might expose
would only let you turn down the argument it's making). Where a convention
genuinely doesn't apply, exclude the file rather than reaching for a setting. An
OmniAuth callbacks controller is the usual example: its actions are named by the
provider, so the `ResourcefulActions` cop isn't helpful.

In `.rubocop.yml`:

```yaml
Thoughtbot/ResourcefulActions:
  Exclude:
    - "app/controllers/users/omniauth_callbacks_controller.rb"
```

In `.standard.yml`, exclusions go under `ignore` rather than under the cop:

```yaml
plugins:
  - rubocop-thoughtbot
ignore:
  - 'app/controllers/users/omniauth_callbacks_controller.rb':
    - Thoughtbot/ResourcefulActions
```

For a single occurrence rather than a whole file, use an inline disable comment:

`# rubocop:disable Thoughtbot/ResourcefulActions`, or `# standard:disable Thoughtbot/ResourcefulActions`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Commands

- `bundle exec rake 'new_cop[Thoughtbot/CopName]'` # Generate new cop (always run this rather than creating the files directly)
- `bundle exec rspec`         # Tests
- `bundle exec rubocop`       # Lint
- `bundle exec rubocop -a`    # Auto-fix lint issues
- `bundle exec rake docs`     # Re-generate docs
- `bundle exec rake`          # Run all: Specs, lint, docs

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rubocop-thoughtbot. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/rubocop-thoughtbot/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Rubocop::Thoughtbot project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/rubocop-thoughtbot/blob/main/CODE_OF_CONDUCT.md).
