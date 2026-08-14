# frozen_string_literal: true

require_relative "lib/rubocop/thoughtbot/version"

Gem::Specification.new do |spec|
  spec.name = "rubocop-thoughtbot"
  spec.version = RuboCop::Thoughtbot::VERSION
  spec.authors = ["Jared Turner"]
  spec.email = ["jared.turner@thoughtbot.com"]

  spec.summary = "A RuboCop Plugin based on thoughtbot's accumulated best-practices."
  spec.description = "A RuboCop Plugin based on thoughtbot's accumulated best-practices."
  spec.homepage = "http://github.com/thoughtbot/rubocop-thoughtbot"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage + "/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore .rspec spec/ .github/ .rubocop.yml])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.metadata["default_lint_roller_plugin"] = "RuboCop::Thoughtbot::Plugin"

  spec.add_dependency "lint_roller", "~> 1.1"
  spec.add_dependency "rubocop", ">= 1.72.2", "< 2"
end
