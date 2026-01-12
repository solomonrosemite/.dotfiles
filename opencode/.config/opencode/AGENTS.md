# agents.md

## Architecture (Vertical Slices)
- Organize by slice (business capability)
- Inside a slice, keep code grouped by responsibility (e.g., api/handlers, schemas/DTOs, workflows, domain rules, persistence/adapters, tests). Names/paths are flexible.
- Do not fear files getting big. That's okay.

## Data-driven composability
- Prefer pure functions "data in → data out" operations with clear inputs/outputs.
- Design operations to compose (pipeline-friendly). Keep transformations separate from IO.
- Side effects (DB/network/time/random) are explicit and live at the edges (adapters/workflows).

## Naming (side effects)
- Reserve these verbs/prefixes for effectful operations (IO, mutations, time, randomness):
  `fetch*`, `load*`, `read*`, `get*` (only when it hits IO), `query*`,
  `save*`, `store*`, `write*`, `update*`, `upsert*`, `delete*`, `remove*`,
  `send*`, `publish*`, `emit*`, `notify*`, `enqueue*`, `dispatch*`,
  `connect*`, `open*`, `close*`, `start*`, `stop*`, `sync*`, `flush*`.
- Prefer verbs like `compute*`, `derive*`, `build*`, `map*`, `filter*`, `format*`, `parse*`, `validate*`, `score*` for pure transforms.

## Files
- Concise files are good; larger cohesive files are also acceptable.

## Comments (eyebrow-only)
- Comments only for intent/why, invariants, constraints, or non-obvious tradeoffs.
- Don't restate what the code already expresses.

## Git
- use conventional commits
- never commit unless explicitly asked by the user to do so
- the user will say "commit" when they want you to commit

- branches should be named after the issue they are solving (e.g. (feature/fix)/ROS-1234-description)
- when merging, use "squash and merge" to keep the commit history clean, unless explicitly asked to do otherwise
