#!/usr/bin/env bash
# Claude Code Mastery — Eval Runner
# Runs test cases against the skill and captures results for scoring.
#
# Usage:
#   bash eval/run-eval.sh                  # Full run (with-skill + baseline)
#   bash eval/run-eval.sh --skill-only     # Skip baseline comparison
#   bash eval/run-eval.sh --case TC-001    # Single test case
#   bash eval/run-eval.sh --baseline-only  # Baseline only (no skill)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
RESULTS_DIR="$SCRIPT_DIR/results/$TIMESTAMP"
SKILL_NAME="claude-code-mastery"

# Parse args
RUN_SKILL=true
RUN_BASELINE=true
SINGLE_CASE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --skill-only)   RUN_BASELINE=false; shift ;;
    --baseline-only) RUN_SKILL=false; shift ;;
    --case)         SINGLE_CASE="$2"; shift 2 ;;
    *) echo "Unknown arg: $1"; exit 1 ;;
  esac
done

# Create results directory
mkdir -p "$RESULTS_DIR/with-skill" "$RESULTS_DIR/baseline"

# ─── Extract test cases from YAML ──────────────────────────────────
# Lightweight YAML parser — extracts id and prompt fields.
# For full YAML parsing, install yq. This handles the test-cases.yaml format.

extract_cases() {
  local yaml_file="$SCRIPT_DIR/test-cases.yaml"
  local current_id=""
  local current_prompt=""
  local in_prompt=false
  local ids=()

  while IFS= read -r line; do
    # Match id field
    if [[ "$line" =~ ^-\ id:\ (.+) ]]; then
      # Save previous case
      if [[ -n "$current_id" ]]; then
        ids+=("$current_id")
        echo "$current_prompt" > "$RESULTS_DIR/prompts/${current_id}.txt"
      fi
      current_id="${BASH_REMATCH[1]}"
      current_prompt=""
      in_prompt=false
    fi

    # Match single-line prompt
    if [[ "$line" =~ ^\ \ prompt:\ \"(.+)\"$ ]]; then
      current_prompt="${BASH_REMATCH[1]}"
      in_prompt=false
    fi

    # Match multi-line prompt start (| or >)
    if [[ "$line" =~ ^\ \ prompt:\ [\|>]$ ]]; then
      in_prompt=true
      current_prompt=""
      continue
    fi

    # Collect multi-line prompt content
    if $in_prompt; then
      # Stop at next top-level field (2-space indent or less)
      if [[ "$line" =~ ^\ \ [a-z] && ! "$line" =~ ^\ \ \ \  ]]; then
        in_prompt=false
      else
        # Strip leading 4 spaces of indentation
        local stripped="${line#    }"
        current_prompt+="${stripped}"$'\n'
      fi
    fi
  done < "$yaml_file"

  # Save last case
  if [[ -n "$current_id" ]]; then
    ids+=("$current_id")
    echo "$current_prompt" > "$RESULTS_DIR/prompts/${current_id}.txt"
  fi

  echo "${ids[@]}"
}

mkdir -p "$RESULTS_DIR/prompts"

echo "=== Claude Code Mastery Eval Runner ==="
echo "Timestamp: $TIMESTAMP"
echo "Results:   $RESULTS_DIR"
echo ""

# Extract test cases
CASE_IDS=($(extract_cases))
echo "Found ${#CASE_IDS[@]} test cases: ${CASE_IDS[*]}"

# Filter to single case if specified
if [[ -n "$SINGLE_CASE" ]]; then
  CASE_IDS=("$SINGLE_CASE")
  echo "Filtering to: $SINGLE_CASE"
fi

echo ""

# ─── Run test cases ────────────────────────────────────────────────

run_case() {
  local case_id="$1"
  local mode="$2"  # "with-skill" or "baseline"
  local prompt_file="$RESULTS_DIR/prompts/${case_id}.txt"
  local output_file="$RESULTS_DIR/$mode/${case_id}.md"
  local prompt_text
  prompt_text=$(cat "$prompt_file")

  echo "  [$mode] Running $case_id..."

  if [[ "$mode" == "with-skill" ]]; then
    # Invoke with skill context by prefixing the prompt
    local full_prompt="Use the $SKILL_NAME skill to answer this: $prompt_text"
    claude -p "$full_prompt" \
      --allowedTools "Read,Glob,Grep" \
      --max-turns 3 \
      --output-format text \
      > "$output_file" 2>/dev/null || {
        echo "EVAL_ERROR: claude command failed for $case_id ($mode)" > "$output_file"
      }
  else
    # Baseline — no skill reference, raw Claude
    claude -p "$prompt_text" \
      --allowedTools "Read,Glob,Grep" \
      --max-turns 3 \
      --output-format text \
      > "$output_file" 2>/dev/null || {
        echo "EVAL_ERROR: claude command failed for $case_id ($mode)" > "$output_file"
      }
  fi

  local token_count
  token_count=$(wc -w < "$output_file" | tr -d ' ')
  echo "  [$mode] $case_id complete ($token_count words)"
}

# Run with-skill
if $RUN_SKILL; then
  echo "── With Skill ──"
  for case_id in "${CASE_IDS[@]}"; do
    run_case "$case_id" "with-skill"
  done
  echo ""
fi

# Run baseline
if $RUN_BASELINE; then
  echo "── Baseline (no skill) ──"
  for case_id in "${CASE_IDS[@]}"; do
    run_case "$case_id" "baseline"
  done
  echo ""
fi

# ─── Score results ─────────────────────────────────────────────────

score_case() {
  local case_id="$1"
  local mode="$2"
  local output_file="$RESULTS_DIR/$mode/${case_id}.md"
  local response
  response=$(cat "$output_file" 2>/dev/null || echo "")

  if [[ "$response" == EVAL_ERROR* ]]; then
    echo "ERROR"
    return
  fi

  local pass=0
  local fail=0
  local total=0
  local critical_fail=false
  local details=""

  # Read assertions from YAML for this case
  local in_case=false
  local in_assertions=false
  local assert_type=""
  local assert_target=""
  local assert_critical="false"

  while IFS= read -r line; do
    if [[ "$line" =~ ^-\ id:\ $case_id ]]; then
      in_case=true
      continue
    fi
    if $in_case && [[ "$line" =~ ^-\ id: ]]; then
      break  # next case
    fi

    if $in_case && [[ "$line" =~ ^\ \ \ \ -\ type:\ (.+) ]]; then
      # Process previous assertion if exists
      if [[ -n "$assert_type" ]]; then
        total=$((total + 1))
        local result="SKIP"

        case "$assert_type" in
          contains)
            if echo "$response" | grep -qi "$assert_target"; then
              result="PASS"; pass=$((pass + 1))
            else
              result="FAIL"; fail=$((fail + 1))
              [[ "$assert_critical" == "true" ]] && critical_fail=true
            fi
            ;;
          not_contains)
            if echo "$response" | grep -qi "$assert_target"; then
              result="FAIL"; fail=$((fail + 1))
              [[ "$assert_critical" == "true" ]] && critical_fail=true
            else
              result="PASS"; pass=$((pass + 1))
            fi
            ;;
          regex)
            if echo "$response" | grep -qiE "$assert_target"; then
              result="PASS"; pass=$((pass + 1))
            else
              result="FAIL"; fail=$((fail + 1))
              [[ "$assert_critical" == "true" ]] && critical_fail=true
            fi
            ;;
          question_before_code)
            local q_pos
            q_pos=$(echo "$response" | grep -n '?' | head -1 | cut -d: -f1)
            local code_pos
            code_pos=$(echo "$response" | grep -n '```' | head -1 | cut -d: -f1)
            if [[ -z "$code_pos" ]] || [[ -n "$q_pos" && "$q_pos" -lt "$code_pos" ]]; then
              result="PASS"; pass=$((pass + 1))
            else
              result="FAIL"; fail=$((fail + 1))
              [[ "$assert_critical" == "true" ]] && critical_fail=true
            fi
            ;;
          json_valid)
            # Extract JSON block and validate
            local json_block
            json_block=$(echo "$response" | sed -n '/```json/,/```/p' | sed '1d;$d')
            if [[ -n "$json_block" ]] && echo "$json_block" | python3 -c "import sys,json;json.load(sys.stdin)" 2>/dev/null; then
              result="PASS"; pass=$((pass + 1))
            elif [[ -n "$json_block" ]] && echo "$json_block" | node -e "process.stdin.on('data',d=>{JSON.parse(d)})" 2>/dev/null; then
              result="PASS"; pass=$((pass + 1))
            else
              result="FAIL"; fail=$((fail + 1))
              [[ "$assert_critical" == "true" ]] && critical_fail=true
            fi
            ;;
          token_limit)
            local word_count
            word_count=$(echo "$response" | wc -w | tr -d ' ')
            # Rough token estimate: words * 1.3
            local est_tokens=$(( word_count * 13 / 10 ))
            if [[ "$est_tokens" -le "${assert_target:-99999}" ]]; then
              result="PASS"; pass=$((pass + 1))
            else
              result="FAIL"; fail=$((fail + 1))
              [[ "$assert_critical" == "true" ]] && critical_fail=true
            fi
            ;;
        esac
        details+="  $assert_type($assert_target): $result"$'\n'
      fi

      assert_type="${BASH_REMATCH[1]}"
      assert_target=""
      assert_critical="false"
    fi

    if $in_case && [[ "$line" =~ ^\ \ \ \ \ \ target:\ (.+) ]]; then
      assert_target="${BASH_REMATCH[1]}"
      # Strip quotes
      assert_target="${assert_target#\"}"
      assert_target="${assert_target%\"}"
    fi

    if $in_case && [[ "$line" =~ ^\ \ \ \ \ \ critical:\ (.+) ]]; then
      assert_critical="${BASH_REMATCH[1]}"
    fi
  done < "$SCRIPT_DIR/test-cases.yaml"

  # Process last assertion
  if [[ -n "$assert_type" ]]; then
    total=$((total + 1))
    local result="SKIP"
    case "$assert_type" in
      contains)
        if echo "$response" | grep -qi "$assert_target"; then
          result="PASS"; pass=$((pass + 1))
        else
          result="FAIL"; fail=$((fail + 1))
          [[ "$assert_critical" == "true" ]] && critical_fail=true
        fi
        ;;
      not_contains)
        if echo "$response" | grep -qi "$assert_target"; then
          result="FAIL"; fail=$((fail + 1))
          [[ "$assert_critical" == "true" ]] && critical_fail=true
        else
          result="PASS"; pass=$((pass + 1))
        fi
        ;;
      regex)
        if echo "$response" | grep -qiE "$assert_target"; then
          result="PASS"; pass=$((pass + 1))
        else
          result="FAIL"; fail=$((fail + 1))
          [[ "$assert_critical" == "true" ]] && critical_fail=true
        fi
        ;;
      question_before_code)
        local q_pos
        q_pos=$(echo "$response" | grep -n '?' | head -1 | cut -d: -f1)
        local code_pos
        code_pos=$(echo "$response" | grep -n '```' | head -1 | cut -d: -f1)
        if [[ -z "$code_pos" ]] || [[ -n "$q_pos" && "$q_pos" -lt "$code_pos" ]]; then
          result="PASS"; pass=$((pass + 1))
        else
          result="FAIL"; fail=$((fail + 1))
          [[ "$assert_critical" == "true" ]] && critical_fail=true
        fi
        ;;
      json_valid)
        local json_block
        json_block=$(echo "$response" | sed -n '/```json/,/```/p' | sed '1d;$d')
        if [[ -n "$json_block" ]] && echo "$json_block" | python3 -c "import sys,json;json.load(sys.stdin)" 2>/dev/null; then
          result="PASS"; pass=$((pass + 1))
        else
          result="FAIL"; fail=$((fail + 1))
          [[ "$assert_critical" == "true" ]] && critical_fail=true
        fi
        ;;
      token_limit)
        local word_count
        word_count=$(echo "$response" | wc -w | tr -d ' ')
        local est_tokens=$(( word_count * 13 / 10 ))
        if [[ "$est_tokens" -le "${assert_target:-99999}" ]]; then
          result="PASS"; pass=$((pass + 1))
        else
          result="FAIL"; fail=$((fail + 1))
          [[ "$assert_critical" == "true" ]] && critical_fail=true
        fi
        ;;
    esac
    details+="  $assert_type($assert_target): $result"$'\n'
  fi

  echo "$pass/$total$(if $critical_fail; then echo ' [CRITICAL FAIL]'; fi)"
  echo "$details" >> "$RESULTS_DIR/$mode/${case_id}.score.txt"
}

# ─── Generate scorecard ───────────────────────────────────────────

generate_scorecard() {
  local scorecard="$RESULTS_DIR/scorecard.md"

  cat > "$scorecard" <<HEADER
# Eval Scorecard — $TIMESTAMP

| Test Case | With Skill | Baseline | Delta |
|-----------|-----------|----------|-------|
HEADER

  for case_id in "${CASE_IDS[@]}"; do
    local skill_score="—"
    local base_score="—"

    if $RUN_SKILL && [[ -f "$RESULTS_DIR/with-skill/${case_id}.md" ]]; then
      skill_score=$(score_case "$case_id" "with-skill")
    fi
    if $RUN_BASELINE && [[ -f "$RESULTS_DIR/baseline/${case_id}.md" ]]; then
      base_score=$(score_case "$case_id" "baseline")
    fi

    echo "| $case_id | $skill_score | $base_score | |" >> "$scorecard"
  done

  echo "" >> "$scorecard"
  echo "## Assertion Details" >> "$scorecard"
  echo "" >> "$scorecard"

  for case_id in "${CASE_IDS[@]}"; do
    echo "### $case_id" >> "$scorecard"
    if [[ -f "$RESULTS_DIR/with-skill/${case_id}.score.txt" ]]; then
      echo "**With Skill:**" >> "$scorecard"
      cat "$RESULTS_DIR/with-skill/${case_id}.score.txt" >> "$scorecard"
    fi
    if [[ -f "$RESULTS_DIR/baseline/${case_id}.score.txt" ]]; then
      echo "**Baseline:**" >> "$scorecard"
      cat "$RESULTS_DIR/baseline/${case_id}.score.txt" >> "$scorecard"
    fi
    echo "" >> "$scorecard"
  done

  echo ""
  echo "=== Scorecard written to $scorecard ==="
  cat "$scorecard"
}

generate_scorecard

echo ""
echo "=== Eval complete ==="
echo "Full results: $RESULTS_DIR/"
