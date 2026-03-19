# Example: Prompt Optimization

Iteratively improve a system prompt by testing it against a fixed set of input/output pairs, scored by an LLM judge.

## Files

```
artifact.md      — the system prompt being improved (agent modifies this)
evaluate.sh      — runs the prompt against test cases, outputs a score
eval/
  test_cases.jsonl  — input/expected pairs (immutable)
  judge.py          — LLM-as-judge scorer (immutable)
program.md       — copy from root, fill in [CONFIGURE] section
```

## How it works

1. `evaluate.sh` reads `artifact.md` as the system prompt
2. For each test case in `test_cases.jsonl`, it calls the LLM with that prompt + the test input
3. `judge.py` scores each response against the expected output (0-10 scale)
4. The average score across all test cases is the final metric

## Setup

1. Create `eval/test_cases.jsonl` with your input/expected pairs:
   ```jsonl
   {"input": "Summarize this article: ...", "expected": "A concise summary covering X, Y, Z"}
   {"input": "Extract the key dates from: ...", "expected": "Jan 5, Mar 12, Nov 30"}
   ```

2. Create `eval/judge.py` — a script that takes a response and expected output and returns a score.
   This can be as simple as exact-match counting, or as sophisticated as an LLM-as-judge call.

3. Configure `evaluate.sh` to wire these together.

4. Copy the root `program.md` and fill in:
   - Artifact file: `artifact.md`
   - Primary metric: `avg_score`
   - Metric direction: `higher_is_better`
   - Time budget: `30 seconds` (or however long your eval takes)

## Metric direction

Higher is better (0-10 scale).
