#!/bin/bash
# evaluate.sh — the immutable evaluation harness
#
# This file is NOT modified by the agent. It runs the artifact through
# a fixed evaluation and outputs a score.
#
# MUST output at least one line matching: score: <number>
# The agent uses this line for keep/discard decisions.
#
# Optionally output additional metrics for logging.
#
# ──────────────────────────────────────────────────────────────────────
# CONFIGURE: Replace the example below with your actual evaluation.
# ──────────────────────────────────────────────────────────────────────

set -euo pipefail

# Example: evaluate a system prompt against test cases using an LLM judge
#
# ARTIFACT="artifact.md"
# TEST_CASES="eval/test_cases.jsonl"
# RESULTS=$(python eval/judge.py --prompt "$ARTIFACT" --cases "$TEST_CASES")
# echo "score: $RESULTS"

# Example: benchmark code performance
#
# python artifact.py < eval/input.txt > /tmp/output.txt
# SCORE=$(python eval/check.py /tmp/output.txt eval/expected.txt)
# echo "score: $SCORE"

# Example: run tests and count pass rate
#
# TOTAL=$(cat eval/test_cases.jsonl | wc -l)
# PASSED=$(bash run_tests.sh artifact.md | grep "PASS" | wc -l)
# SCORE=$(echo "scale=4; $PASSED / $TOTAL" | bc)
# echo "score: $SCORE"

echo "ERROR: evaluate.sh is not configured yet."
echo "Edit this file to define how the artifact is scored."
echo "See the examples above, or check examples/ for complete setups."
exit 1
