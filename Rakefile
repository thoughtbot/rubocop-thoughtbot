# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rubocop/rake_task"
require "yard"

RSpec::Core::RakeTask.new(:spec) do |task|
  task.verbose = false
end

RuboCop::RakeTask.new

task default: %i[spec rubocop verify_docs]

YARD::Rake::YardocTask.new(:yard_registry) do |task|
  task.files = ["lib/rubocop/cop/**/*.rb"]
  task.options = ["--no-output", "--no-progress", "--no-stats"]
end

desc "Generate cop documentation from the cops' YARD comments"
task docs: :yard_registry do
  require "rubocop"
  require "rubocop/cops_documentation_generator"

  CopsDocumentationGenerator.new(
    departments: ["Thoughtbot"],
    plugin_name: "rubocop-thoughtbot"
  ).call
end

desc "Check the committed cop documentation still matches the cops"
task verify_docs: :docs do
  drift = `git status --porcelain -- docs`

  unless drift.empty?
    abort <<~MESSAGE
      Generated cop documentation is out of date:

      #{drift}
      `rake docs` has already regenerated it. Review and commit `docs/`.
    MESSAGE
  end
end

desc "Generate a new cop with a template"
task :new_cop, [:cop] do |_task, args|
  require "rubocop"

  cop_name = args.fetch(:cop) do
    warn "usage: bundle exec rake new_cop[Department/Name]"
    exit!
  end

  generator = RuboCop::Cop::Generator.new(cop_name)

  generator.write_source
  generator.write_spec
  generator.inject_require(root_file_path: "lib/rubocop/cop/thoughtbot_cops.rb")
  generator.inject_config(config_file_path: "config/default.yml")

  puts generator.todo
end
