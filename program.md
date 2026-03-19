# autoloop

This is an experiment to have an LLM iteratively improve anything with a measurable metric.

Forked from [karpathy/autoresearch](https://github.com/karpathy/autoresearch), which proved this pattern for ML model training. This version generalizes the loop to work with any domain where you can define an automated evaluator.

## Setup

To set up a new experiment, work with the user to:

1. **Agree on a run tag**: propose a tag based on today's date (e.g. `mar19`). The branch `autoloop/<tag>` must not already exist — this is a fresh run.
2. **Create the branch**: `git checkout -b autoloop/<tag>` from current master.
3. **Read the in-scope files**: The repo is small. Read these files for full context:
   - `README.md` — repository context.
   - `evaluate.sh` — the evaluation harness. Do not modify. It runs the artifact through a fixed evaluation and outputs a score.
   - The artifact file(s) defined below — these are what you modify.
4. **Verify the evaluator works**: Run `bash evaluate.sh` and confirm it produces a score line. If it errors, tell the human to fix the evaluator setup first.
5. **Initialize results.tsv**: Create `results.tsv` with just the header row. The baseline will be recorded after the first run.
6. **Confirm and go**: Confirm setup looks good.

Once you get confirmation, kick off the experimentation.

## [CONFIGURE] Domain definition

Fill in this section to define what you're optimizing. Delete these instructions and replace with your specifics.

**Artifact file(s):** `[the file(s) the agent modifies — e.g. system_prompt.txt, sort.py, SKILL.md]`

**Evaluation command:** `bash evaluate.sh`

**Primary metric:** `[metric name — e.g. accuracy, ops_per_sec, quality_score]`

**Metric direction:** `[lower_is_better or higher_is_better]`

**Time budget per experiment:** `[e.g. 2 minutes, 30 seconds — keep it short for fast iteration]`

**Goal:** `[one sentence — e.g. "Get the highest accuracy score on the test suite"]`

## Experimentation

**What you CAN do:**
- Modify the artifact file(s) defined above — these are the only files you edit. Everything within them is fair game.

**What you CANNOT do:**
- Modify `evaluate.sh`. It is read-only. It contains the fixed evaluation harness and scoring logic.
- Install new packages or add dependencies unless the human explicitly approves.
- Modify the test cases, scoring rubric, or evaluation data. Those are ground truth.

**Simplicity criterion**: All else being equal, simpler is better. A small improvement that adds ugly complexity is not worth it. Conversely, removing something and getting equal or better results is a great outcome — that's a simplification win. When evaluating whether to keep a change, weigh the complexity cost against the improvement magnitude.

**The first run**: Your very first run should always be to establish the baseline, so run the evaluator on the artifact as-is.

## Output format

The evaluator should print a summary with at least this line:

```
score: [number]
```

You can extract the metric from the log file:

```
grep "^score:" run.log
```

If the evaluator outputs additional metrics, log them but use only the primary `score` for keep/discard decisions.

## Logging results

When an experiment is done, log it to `results.tsv` (tab-separated, NOT comma-separated — commas break in descriptions).

The TSV has a header row and 4 columns:

```
commit	score	status	description
```

1. git commit hash (short, 7 chars)
2. score achieved (e.g. 0.8532) — use 0.0000 for crashes
3. status: `keep`, `discard`, or `crash`
4. short text description of what this experiment tried

Example:

```
commit	score	status	description
a1b2c3d	0.7200	keep	baseline
b2c3d4e	0.7650	keep	add chain-of-thought reasoning step
c3d4e5f	0.7100	discard	remove examples section
d4e5f6g	0.0000	crash	malformed output (evaluator parse error)
```

## The experiment loop

The experiment runs on a dedicated branch (e.g. `autoloop/mar19`).

LOOP FOREVER:

1. Look at the git state: the current branch/commit we're on
2. Modify the artifact file(s) with an experimental idea.
3. git commit
4. Run the experiment: `bash evaluate.sh > run.log 2>&1` (redirect everything — do NOT use tee or let output flood your context)
5. Read out the results: `grep "^score:" run.log`
6. If the grep output is empty, the run crashed. Run `tail -n 50 run.log` to read the error and attempt a fix. If you can't get things to work after more than a few attempts, give up on this idea.
7. Record the results in the tsv (NOTE: do not commit the results.tsv file, leave it untracked by git)
8. If score improved (check the metric direction defined above), you "advance" the branch, keeping the git commit
9. If score is equal or worse, you git reset back to where you started

The idea is that you are a completely autonomous researcher trying things out. If they work, keep. If they don't, discard. And you're advancing the branch so that you can iterate. If you feel like you're getting stuck in some way, you can rewind but you should probably do this very very sparingly (if ever).

**Timeout**: Each experiment should take roughly the configured time budget (+ a few seconds for setup overhead). If a run exceeds 2x the time budget, kill it and treat it as a failure (discard and revert).

**Crashes**: If a run crashes or errors, use your judgment: If it's something dumb and easy to fix (e.g. a syntax error, a missing file), fix it and re-run. If the idea itself is fundamentally broken, just skip it, log "crash" as the status in the tsv, and move on.

**NEVER STOP**: Once the experiment loop has begun (after the initial setup), do NOT pause to ask the human if you should continue. Do NOT ask "should I keep going?" or "is this a good stopping point?". The human might be asleep, or gone from a computer and expects you to continue working *indefinitely* until you are manually stopped. You are autonomous. If you run out of ideas, think harder — re-read the artifact for new angles, try combining previous near-misses, try more radical changes, try simplifying. The loop runs until the human interrupts you, period.

As an example use case, a user might leave you running while they sleep. The user then wakes up to experimental results, all completed by you while they slept!
