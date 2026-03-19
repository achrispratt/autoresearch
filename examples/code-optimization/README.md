# Example: Code Optimization

Iteratively optimize a function for speed while maintaining correctness.

## Files

```
artifact.py      — the code being optimized (agent modifies this)
evaluate.sh      — runs benchmark + correctness check, outputs score
eval/
  benchmark.py    — timing harness (immutable)
  test_input.txt  — fixed benchmark input (immutable)
  expected.txt    — expected output for correctness (immutable)
program.md       — copy from root, fill in [CONFIGURE] section
```

## How it works

1. `evaluate.sh` first runs a correctness check: `python artifact.py < eval/test_input.txt`
2. If output doesn't match `eval/expected.txt`, score is 0 (correctness is non-negotiable)
3. If correct, runs `eval/benchmark.py` which times 100 executions and reports ops/sec
4. ops/sec is the score — higher is better

## Setup

1. Put your function in `artifact.py` — it should read from stdin and write to stdout
2. Create `eval/test_input.txt` with representative benchmark data
3. Create `eval/expected.txt` with the correct output
4. Create `eval/benchmark.py` — a simple timing loop

5. Configure `evaluate.sh`:
   ```bash
   #!/bin/bash
   set -euo pipefail

   # Correctness check
   OUTPUT=$(python artifact.py < eval/test_input.txt)
   EXPECTED=$(cat eval/expected.txt)
   if [ "$OUTPUT" != "$EXPECTED" ]; then
     echo "FAIL: output doesn't match expected"
     echo "score: 0"
     exit 0
   fi

   # Benchmark
   SCORE=$(python eval/benchmark.py)
   echo "score: $SCORE"
   ```

6. Fill in `program.md`:
   - Artifact file: `artifact.py`
   - Primary metric: `ops_per_sec`
   - Metric direction: `higher_is_better`
   - Time budget: `60 seconds`

## Metric direction

Higher is better (ops/sec). Score of 0 means correctness failure.
