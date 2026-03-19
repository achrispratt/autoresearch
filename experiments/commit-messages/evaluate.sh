#!/bin/bash
# evaluate.sh — commit message quality evaluator
#
# Runs the system prompt in artifact.md against 12 real git diffs,
# then scores each generated commit message against the human-written
# reference using an LLM judge.
#
# Output: score: <number> (0-10 scale, higher is better)
#
# DO NOT MODIFY during an experiment run.
set -euo pipefail

ARTIFACT="artifact.md"
TEST_DIR="eval/test_cases"
TOTAL_SCORE=0
COUNT=0
RESULTS=""

echo "=== Commit Message Evaluation ==="
echo ""

for diff_file in "$TEST_DIR"/*.diff; do
  num=$(basename "$diff_file" .diff)
  ref_file="$TEST_DIR/${num}.ref"

  if [ ! -f "$ref_file" ]; then
    echo "SKIP: no reference for $num"
    continue
  fi

  ref=$(cat "$ref_file")
  diff_content=$(cat "$diff_file")

  # Generate a commit message using the artifact prompt + the diff
  generated=$(echo "" | claude -p \
    --model haiku \
    --allowedTools "" \
    --max-budget-usd 0.50 \
    "$(cat <<PROMPT
<system>
$(cat "$ARTIFACT")
</system>

Here is the git diff to write a commit message for:

\`\`\`diff
$diff_content
\`\`\`
PROMPT
)" 2>/dev/null | tail -1)

  # Score the generated message against the reference
  judge_score=$(echo "" | claude -p \
    --model haiku \
    --allowedTools "" \
    --max-budget-usd 0.50 \
    "$(cat <<JUDGE
You are a commit message quality judge. Score the GENERATED commit message against the REFERENCE on a 0-10 scale.

REFERENCE (human-written, gold standard):
$ref

GENERATED (to be scored):
$generated

Scoring rubric:
- Type prefix correctness (feat/fix/refactor/style/etc): 0-2 points
- Captures the essence of the change (what and why): 0-3 points
- Conciseness and clarity: 0-2 points
- Style match (conventional commits, imperative mood, lowercase): 0-2 points
- Appropriate scope usage: 0-1 point

Output ONLY a single integer 0-10. Nothing else.
JUDGE
)" 2>/dev/null | grep -oE '[0-9]+' | head -1)

  # Default to 0 if judge failed
  judge_score=${judge_score:-0}

  # Clamp to 0-10
  if [ "$judge_score" -gt 10 ] 2>/dev/null; then judge_score=10; fi
  if [ "$judge_score" -lt 0 ] 2>/dev/null; then judge_score=0; fi

  TOTAL_SCORE=$((TOTAL_SCORE + judge_score))
  COUNT=$((COUNT + 1))

  RESULTS="${RESULTS}  case ${num}: ${judge_score}/10  ref=\"${ref}\"  gen=\"${generated}\"\n"
  echo "  case ${num}: ${judge_score}/10"
done

echo ""
echo "--- Results ---"
echo -e "$RESULTS"

if [ "$COUNT" -gt 0 ]; then
  # Calculate average with 4 decimal places
  AVG=$(echo "scale=4; $TOTAL_SCORE / $COUNT" | bc)
  echo "total: $TOTAL_SCORE / $((COUNT * 10))"
  echo "cases: $COUNT"
  echo "score: $AVG"
else
  echo "ERROR: no test cases found"
  echo "score: 0.0000"
fi
