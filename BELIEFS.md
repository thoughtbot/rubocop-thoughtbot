# Beliefs

This gem is a set of opinions about writing Ruby and Rails, but this isn't where
those live (each cop carries its own argument, in its documentation).

This is the layer above: what we believe about building the cops, and about the
experience of the person on the receiving end of one.

Every entry states a belief, then how it applies. If an entry can't produce a
practical half, it isn't a belief we hold yet, it's a preference still looking
for its justification.

## Offence messages teach

The reader may be meeting this convention for the first time, and the message
may be the only documentation they ever read. Editors truncate, CI logs scroll,
and nobody clicks through to a rule reference they didn't go looking for. A
message that assumes you already know the convention only helps the people who
didn't need it.

So a message has to stand on its own: name what is wrong here, say what to do
about it, and leave the reader somewhere to go for the reasoning.

Complete beats short. But a message is paid for once per offence, and these cops
can fire several times in a single file. Every clause has to earn its place on
the twentieth line of a CI log.

**In practice**

- Name the specific code, interpolated — `` `edit_password` ``, not "this method".
- State the remedy, not just the violation. Where there is more than one, list them.
- Give the why in a clause, where one fits.
- Link the reasoning. If there's no article justifying the cop, write the article
  before writing the cop.
- Address the code, never the developer. "Avoid `let`", not "don't use `let`".
- Put worked examples in the cop's `@example` blocks. A message is one line and
  can't hold them.
