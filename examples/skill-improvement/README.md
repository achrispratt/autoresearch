# Example: Skill / Instruction Improvement

Iteratively improve a Claude Code skill (or any agent instruction set) by running it against test tasks and scoring output quality.

## Files

```
artifact.md      — the skill/instructions being improved (agent modifies this)
evaluate.sh      — runs the skill against test tasks, scores results
eval/
  tasks.jsonl     — test tasks with acceptance criteria (immutable)
  run_task.sh     — executes one task using the skill (immutable)
  score.py        — scores task output against criteria (immutable)
program.md       — copy from root, fill in [CONFIGURE] section
```

## How it works

1. `evaluate.sh` reads each task from `eval/tasks.jsonl`
2. For each task, `run_task.sh` invokes an agent with `artifact.md` as its instructions
3. `score.py` evaluates the agent's output against the task's acceptance criteria
4. Average score across all tasks is the final metric

## The evaluation challenge

Skill improvement is **harder to evaluate** than code or prompts because:
- Agent behavior is non-deterministic (same skill, different outputs)
- Quality is partially subjective
- Tasks can take a while to run

Mitigations:
- **Run each task 2-3 times** and average the scores to reduce noise
- **Use concrete acceptance criteria** ("output must contain X", "must not contain Y") rather than subjective judgments
- **Keep tasks small** (30-60 seconds each) so the full eval completes in a few minutes
- **Use LLM-as-judge with a rubric** for aspects that can't be checked mechanically

## Setup

1. Write your initial skill in `artifact.md`

2. Create `eval/tasks.jsonl`:
   ```jsonl
   {"task": "Write a function that reverses a string", "criteria": ["function exists", "handles empty string", "handles unicode"]}
   {"task": "Fix the bug in this code: ...", "criteria": ["bug is fixed", "no new bugs introduced", "explanation provided"]}
   ```

3. Create `eval/run_task.sh` — invokes an agent with the skill and a task, captures output

4. Create `eval/score.py` — scores output against criteria (0-10)

5. Fill in `program.md`:
   - Artifact file: `artifact.md`
   - Primary metric: `avg_quality`
   - Metric direction: `higher_is_better`
   - Time budget: `5 minutes` (depends on how many tasks and how long each takes)

## Metric direction

Higher is better (0-10 quality scale).

## Warning: recursive improvement

If the skill being improved is itself used to evaluate or improve other things,
you can get reward hacking — the skill optimizes for the metric rather than
actual quality. Keep the evaluator completely independent of the artifact.
