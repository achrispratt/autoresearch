#!/bin/bash
# evaluate.sh — the immutable evaluation harness
#
# This file is NOT modified by the agent during experiment runs.
# It runs the artifact through a fixed evaluation and outputs a score.
#
# REQUIREMENTS:
# - MUST output at least one line matching: score: <number>
# - The agent uses this line for keep/discard decisions.
# - Should be deterministic (or as close as possible).
# - Should complete within the time budget defined in program.md.
#
# ──────────────────────────────────────────────────────────────────────
# CONFIGURE: Replace the scaffold below with your actual evaluation.
# ──────────────────────────────────────────────────────────────────────
set -euo pipefail

ARTIFACT="artifact.md"

# ── Example: LLM-as-judge prompt evaluation ──────────────────────────
#
# TEST_DIR="eval/test_cases"
# TOTAL=0; COUNT=0
#
# for input_file in "$TEST_DIR"/*.input; do
#   num=$(basename "$input_file" .input)
#   ref=$(cat "$TEST_DIR/${num}.expected")
#
#   generated=$(echo "" | claude -p --model haiku --allowedTools "" \
#     --max-budget-usd 0.50 \
#     "<system>$(cat $ARTIFACT)</system> $(<"$input_file")" 2>/dev/null | tail -1)
#
#   points=$(echo "" | claude -p --model haiku --allowedTools "" \
#     --max-budget-usd 0.50 \
#     "Score GENERATED vs REFERENCE on 0-10. REFERENCE: $ref GENERATED: $generated. Output ONLY an integer." \
#     2>/dev/null | grep -oE '[0-9]+' | head -1)
#
#   TOTAL=$((TOTAL + ${points:-0}))
#   COUNT=$((COUNT + 1))
# done
#
# echo "score: $(echo "scale=4; $TOTAL / $COUNT" | bc)"
#
# ── Example: Code benchmark ──────────────────────────────────────────
#
# OUTPUT=$(python artifact.py < eval/input.txt)
# if [ "$OUTPUT" != "$(cat eval/expected.txt)" ]; then
#   echo "score: 0"; exit 0
# fi
# echo "score: $(python eval/benchmark.py)"
#
# ── Example: Test pass rate ──────────────────────────────────────────
#
# TOTAL=$(ls eval/test_cases/*.json | wc -l)
# PASSED=$(bash run_tests.sh | grep -c PASS)
# echo "score: $(echo "scale=4; $PASSED / $TOTAL" | bc)"
#
# ─────────────────────────────────────────────────────────────────────

echo "ERROR: evaluate.sh is not configured yet."
echo "Replace this scaffold with your evaluation logic."
echo "Must output a line matching: score: <number>"
exit 1
