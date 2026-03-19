# autoloop

Domain-agnostic autonomous experimentation. Forked from [karpathy/autoresearch](https://github.com/karpathy/autoresearch).

An agent modifies an artifact, evaluates it, keeps improvements, reverts failures, and repeats indefinitely.

## Repo structure

```
templates/               ← PRISTINE TEMPLATES (never modify directly)
  program.md             ← experiment loop instructions template
  artifact.md            ← mutable artifact template
  evaluate.sh            ← evaluation harness template

experiments/             ← ONE DIRECTORY PER EXPERIMENT (self-contained)
  commit-messages/       ← example: commit message prompt optimization
    program.md           ← configured loop instructions
    artifact.md          ← the system prompt being improved
    evaluate.sh          ← scoring harness (12 real diffs, LLM-as-judge)
    eval/test_cases/     ← immutable test data
  [your-experiment]/     ← create new ones from templates
    ...
```

## How to start an experiment

### If an experiment already exists for what the human wants:

1. `cd experiments/[name]/`
2. Read `program.md` in that directory
3. Follow its setup and experiment loop instructions

### If no existing experiment matches — create one:

1. Pick a short, descriptive directory name (e.g. `code-review`, `skill-debugging`, `api-prompts`)
2. Create the experiment directory from templates:
   ```bash
   EXPERIMENT="experiments/[name]"
   mkdir -p "$EXPERIMENT/eval"
   cp templates/program.md "$EXPERIMENT/program.md"
   cp templates/artifact.md "$EXPERIMENT/artifact.md"
   cp templates/evaluate.sh "$EXPERIMENT/evaluate.sh"
   ```
3. Work with the human to configure the three files:
   - **program.md** — fill in the `[BRACKETED]` placeholders: experiment name, artifact description, metric, direction, time budget, goal
   - **artifact.md** — replace the placeholder with the actual initial artifact (prompt, code, skill, config, whatever)
   - **evaluate.sh** — replace the scaffold with actual evaluation logic. Must output `score: <number>`
4. Create `eval/` subdirectory with test cases, expected outputs, or whatever the evaluator needs
5. Commit the configured experiment: `git add experiments/[name]/ && git commit`
6. Verify the evaluator works: `cd experiments/[name] && bash evaluate.sh`
7. Then follow the `program.md` setup and loop instructions

### Important rules:

- **Never modify files in `templates/`.** Always copy to a new experiment directory first.
- **Never modify `evaluate.sh` or `eval/` during an experiment run.** The evaluator is immutable while the loop is active.
- **Each experiment is self-contained.** All paths in evaluate.sh and program.md are relative to the experiment directory.
- **Run all commands from the experiment directory** (`cd experiments/[name]` first).
- **results.tsv stays untracked** — don't commit it. It's the experiment log.
- **Experiment branches use the pattern** `autoloop/[experiment-name]/<tag>` (e.g. `autoloop/commit-messages/mar19`).
- **Completed experiments stay in the repo** for future iteration. If the human wants to resume improving a previous experiment, just create a new branch tag and keep going.

## The autoloop pattern

```
┌─── Human configures ──────────────────────────────────────────┐
│                                                               │
│  program.md    → what to optimize, rules, loop instructions   │
│  artifact.md   → initial version of the thing being improved  │
│  evaluate.sh   → how to score it (immutable during runs)      │
│  eval/         → test data, expected outputs (immutable)       │
│                                                               │
└───────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─── Agent loops forever ───────────────────────────────────────┐
│                                                               │
│  1. Modify artifact.md with an idea                           │
│  2. git commit                                                │
│  3. bash evaluate.sh > run.log 2>&1                           │
│  4. grep "^score:" run.log                                    │
│  5. Score improved? → keep commit                             │
│     Score worse?    → git reset --hard HEAD~1                 │
│  6. Log to results.tsv                                        │
│  7. GOTO 1 (never stop, never ask permission)                 │
│                                                               │
└───────────────────────────────────────────────────────────────┘
```
