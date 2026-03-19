# autoloop

Domain-agnostic autonomous experimentation template. Forked from [karpathy/autoresearch](https://github.com/karpathy/autoresearch).

## What this repo is

A template for running autonomous AI experiment loops on **anything with a measurable metric**. An agent modifies an artifact, evaluates it, keeps improvements, reverts failures, and repeats indefinitely.

This is NOT an ML training repo. The original autoresearch proved the pattern with PyTorch/GPU training. This fork strips the ML code and provides generic scaffolding.

## Repo structure

```
program.md       — THE MAIN FILE. Agent experiment loop instructions. Read this first.
artifact.md      — Placeholder mutable artifact. Replace with whatever you're improving.
evaluate.sh      — Placeholder evaluation harness. Configure with your scoring logic.
examples/        — Concrete example setups for common domains.
```

## How the pattern works

```
Human writes program.md (what to optimize, how to evaluate)
       │
       ▼
Agent reads program.md → modifies artifact → runs evaluate.sh → checks score
       │                                                              │
       ├── score improved → git commit stays (keep)                   │
       └── score worse    → git reset (revert)                        │
       │                                                              │
       └──────────────────── LOOP FOREVER ◄───────────────────────────┘
```

## Rules

- **program.md** is the agent's instructions. Human edits this.
- **artifact.md** (or whatever file is configured) is what the agent modifies. Agent edits this.
- **evaluate.sh** is the immutable scoring harness. Nobody edits this during a run.
- **results.tsv** logs all experiments. Untracked by git — don't commit it.
- Experiments run on dedicated branches: `autoloop/<tag>`
- The agent runs autonomously and does not stop to ask permission.

## To start a run

Open this repo in Claude Code (or any agent) and say:

```
Read program.md and let's kick off a new experiment. Let's do the setup first.
```

## Before first use

1. Replace `artifact.md` with whatever you're optimizing
2. Configure `evaluate.sh` with your scoring logic (must output `score: <number>`)
3. Fill in the `[CONFIGURE]` section in `program.md`
