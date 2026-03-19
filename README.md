# autoloop

A domain-agnostic template for autonomous AI experimentation loops.

Forked from [karpathy/autoresearch](https://github.com/karpathy/autoresearch), which proved this pattern for ML model training on a single GPU. This fork generalizes the loop to work with **anything that has a measurable metric** — prompts, skills, code, configurations, or any other artifact an agent can modify and evaluate.

## The pattern

The core idea from autoresearch: give an AI agent a mutable artifact, an immutable evaluator, and a clear metric. Let it experiment autonomously. Keep improvements, revert failures, log everything. Repeat forever.

```
program.md       — agent instructions: the experiment loop (human edits this)
artifact.md      — the thing being improved (agent edits this)
evaluate.sh      — the scoring harness (nobody edits this during a run)
```

Three files. Same structure as the original, generalized beyond ML.

## How it works

1. You define **what** to improve (the artifact) and **how** to measure it (the evaluator)
2. Point an agent at `program.md` and let it go
3. The agent modifies the artifact, runs the evaluator, checks if the score improved
4. Better? Keep the commit. Worse? `git reset`. Log either way. Repeat.
5. You come back to a `results.tsv` of everything it tried

## Quick start

```bash
# 1. Configure your domain
#    - Replace artifact.md with whatever you're optimizing
#    - Fill in evaluate.sh with your scoring logic
#    - Fill in the [CONFIGURE] section in program.md

# 2. Verify the evaluator works
bash evaluate.sh

# 3. Spin up your agent (Claude Code, Codex, etc.) and prompt:
```

```
Read program.md and let's kick off a new experiment. Let's do the setup first.
```

## Project structure

```
program.md       — agent instructions: setup, loop, logging, autonomy rules
artifact.md      — placeholder mutable artifact (replace with your own)
evaluate.sh      — placeholder evaluation harness (configure for your domain)
examples/
  prompt-optimization/   — optimize a system prompt with LLM-as-judge
  code-optimization/     — optimize code for speed with correctness checks
  skill-improvement/     — improve agent skills/instructions
```

## Design choices (preserved from autoresearch)

- **Single artifact to modify.** The agent only touches the artifact file(s). Keeps scope manageable and diffs reviewable.
- **Fixed evaluation harness.** The evaluator is immutable during a run. This prevents the agent from gaming the metric by changing the test.
- **Git as experiment tracking.** No MLflow, no W&B. Branches, commits, and a TSV file. Dead simple.
- **Autonomous operation.** The agent runs indefinitely until manually stopped. No "should I keep going?" interruptions.
- **Simplicity criterion.** All else being equal, simpler is better. Improvements that add ugly complexity aren't worth it.

## What makes a good evaluator

The quality of results depends entirely on your evaluator. Good evaluators are:

- **Automated** — no human in the loop per experiment
- **Fast** — seconds to low minutes, so you get many iterations
- **Honest** — hard to game (the agent will find shortcuts if they exist)
- **Deterministic** — same input should produce the same score (or close to it)

| Domain | Eval difficulty | Why |
|--------|----------------|-----|
| Code performance | Easy | Benchmark time is objective and exact |
| Test pass rate | Easy | But watch for gaming (trivial passing tests) |
| Prompt quality | Medium | LLM-as-judge works but is noisy |
| Skill/agent quality | Medium | Needs good test tasks and rubrics |
| UI/UX quality | Hard | Mostly subjective, partial automation possible |

## Lineage

This template preserves the structural discipline of [karpathy/autoresearch](https://github.com/karpathy/autoresearch):
- The experiment loop (keep/revert, TSV logging, crash handling)
- The autonomy directive ("never stop")
- The simplicity criterion
- The three-file architecture (instructions + artifact + evaluator)
- Git branch-per-run isolation

The ML-specific code (PyTorch model, data loading, BPB metric) has been replaced with domain-agnostic scaffolding.

## License

MIT
