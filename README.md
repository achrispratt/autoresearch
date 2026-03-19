# autoloop

A domain-agnostic template for autonomous AI experimentation loops.

Forked from [karpathy/autoresearch](https://github.com/karpathy/autoresearch), which proved this pattern for ML model training on a single GPU. This fork generalizes the loop to work with **anything that has a measurable metric** — prompts, skills, code, configurations, or any other artifact an agent can modify and evaluate.

## The pattern

Give an AI agent a mutable artifact, an immutable evaluator, and a clear metric. Let it experiment autonomously. Keep improvements, revert failures, log everything. Repeat forever.

## Repo structure

```
templates/                  — pristine starter files (never modify directly)
  program.md                — experiment loop instructions
  artifact.md               — mutable artifact placeholder
  evaluate.sh               — evaluation harness scaffold

experiments/                — one directory per experiment (self-contained)
  commit-messages/          — example: optimize a commit message prompt
    program.md              — configured for commit message generation
    artifact.md             — the system prompt being improved
    evaluate.sh             — scores against 12 real diffs via LLM-as-judge
    eval/test_cases/        — real diffs + human-written reference messages
```

## Quick start

```bash
# 1. To run an existing experiment:
cd experiments/commit-messages
#    Then open Claude Code and say: "Read program.md and let's start."

# 2. To create a new experiment:
#    Open Claude Code at the repo root and say what you want to improve.
#    The agent will create a new experiment directory from templates.
```

## Creating a new experiment

1. Copy `templates/` files into a new `experiments/[name]/` directory
2. Configure `program.md` — fill in what you're optimizing, the metric, and the goal
3. Configure `artifact.md` — replace with the initial version of whatever you're improving
4. Configure `evaluate.sh` — wire up your scoring logic (must output `score: <number>`)
5. Add test data to `eval/` if your evaluator needs it
6. Point an agent at the experiment's `program.md` and let it run

## Design choices (preserved from autoresearch)

- **Single artifact to modify.** Keeps scope manageable and diffs reviewable.
- **Fixed evaluation harness.** Prevents the agent from gaming the metric.
- **Git as experiment tracking.** Branches, commits, and a TSV file. No infrastructure.
- **Autonomous operation.** Runs indefinitely until manually stopped.
- **Simplicity criterion.** All else being equal, simpler is better.
- **Experiments are preserved.** Each experiment directory is a complete record — resume any time.

## What makes a good evaluator

| Domain | Eval difficulty | Notes |
|--------|----------------|-------|
| Code performance | Easy | Benchmark time is objective |
| Test pass rate | Easy | Watch for gaming |
| Prompt quality | Medium | LLM-as-judge is noisy but works |
| Skill/agent quality | Medium | Needs good test tasks and rubrics |
| UI/UX quality | Hard | Partially automatable |

## Lineage

Preserves the structural discipline of [karpathy/autoresearch](https://github.com/karpathy/autoresearch): the experiment loop, keep/revert via git, TSV logging, autonomous operation, and simplicity criterion. ML-specific code replaced with domain-agnostic templates.

## License

MIT
