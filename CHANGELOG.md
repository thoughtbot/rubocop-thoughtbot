## [Unreleased]

## [0.1.1] - 2026-08-14

### Fixed

- `Thoughtbot/NoBefore` and `Thoughtbot/NoLet` now only flag a call that belongs to
  an RSpec example group (`describe`, `context`, `feature`, `shared_examples` and
  friends, with or without an `RSpec.` receiver). Sinatra and Grape define a
  `before` of their own, so a fake app under `spec/support` was being flagged for a
  hook that has nothing to do with RSpec.

## [0.1.0] - 2026-08-14

- Initial release
  - See [README](README.md) for context
  - Releases with only [3 cops](docs/modules/ROOT/pages/cops_thoughtbot.adoc) to get started. Expect more as we iterate
