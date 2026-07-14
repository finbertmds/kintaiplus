#!/bin/bash
# Script tự động chạy tất cả các test lấy Rakuten point apps hàng ngày
# Nếu test failed, retry tối đa 3 lần (lần đầu + 2 lần retry)

PROJECT_DIR="/Users/finbertmds/Documents/1code/kintaiplus"
LOG_DIR="$PROJECT_DIR/logs"
LOG_FILE="$LOG_DIR/kintaiplus_$(date '+%Y%m%d_%H%M%S').log"
RUN_SUMMARY_LOG="$LOG_DIR/run_summary.log"
RUN_ID="$(date '+%Y%m%d_%H%M%S')"
RUN_START_TIME="$(date '+%Y-%m-%d %H:%M:%S')"
RUN_START_EPOCH="$(date '+%s')"
MAX_ATTEMPTS=3
PASS=0
FAIL=0
RUN_STATUS="FAILED"

mkdir -p "$LOG_DIR"

echo "========================================" | tee -a "$LOG_FILE"
echo "KintaiPlus Run: $RUN_START_TIME" | tee -a "$LOG_FILE"
echo "Summary log: $RUN_SUMMARY_LOG" | tee -a "$LOG_FILE"
echo "========================================" | tee -a "$LOG_FILE"

cd "$PROJECT_DIR" || exit 1

echo "Node version:" | tee -a "$LOG_FILE"
node -v >> "$LOG_FILE" 2>&1

npm install >> "$LOG_FILE" 2>&1

# if parameter is clock_in, only run clock_in test
if [ "$1" == "clock_in" ]; then
  COMMAND=("npm run clock_in")
  echo "Running command: ${COMMAND[*]}" | tee -a "$LOG_FILE"
  if $COMMAND >> "$LOG_FILE" 2>&1; then
    echo "✅ PASSED: clock_in ($(date '+%H:%M:%S'))" | tee -a "$LOG_FILE"
  else
    echo "  ❌ Failed: clock_in ($(date '+%H:%M:%S'))" | tee -a "$LOG_FILE"
  fi
elif [ "$1" == "clock_out" ]; then
  COMMAND=("npm run clock_out")
  echo "Running command: ${COMMAND[*]}" | tee -a "$LOG_FILE"
  if $COMMAND >> "$LOG_FILE" 2>&1; then
    echo "✅ PASSED: clock_out ($(date '+%H:%M:%S'))" | tee -a "$LOG_FILE"
  else
    echo "  ❌ Failed: clock_out ($(date '+%H:%M:%S'))" | tee -a "$LOG_FILE"
  fi
fi

echo "" | tee -a "$LOG_FILE"
echo "========================================" | tee -a "$LOG_FILE"
echo "Finished: $(date '+%Y-%m-%d %H:%M:%S')" | tee -a "$LOG_FILE"
echo "========================================" | tee -a "$LOG_FILE"

# remove logs older than 7 days
find "$LOG_DIR" -type f -name "kintaiplus_*.log" -mtime +7 -exec rm {} \;