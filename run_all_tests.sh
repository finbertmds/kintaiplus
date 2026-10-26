#!/bin/bash
# Script tự động chạy tất cả các test lấy Rakuten point apps hàng ngày
# Nếu test failed, retry tối đa 3 lần (lần đầu + 2 lần retry)

# Chỉ cho phép các npm script chấm công đã định nghĩa.
TASK="${1:-}"
case "$TASK" in
  clock_in|clock_out) ;;
  *)
    echo "Usage: $0 {clock_in|clock_out}" >&2
    exit 2
    ;;
esac

PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "Project directory: $PROJECT_DIR"
cd "$PROJECT_DIR"
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

COMMAND=(npm run "$TASK")
echo "Running command: ${COMMAND[*]}" | tee -a "$LOG_FILE"
EXIT_CODE=0
if "${COMMAND[@]}" >> "$LOG_FILE" 2>&1; then
  echo "✅ PASSED: $TASK ($(date '+%H:%M:%S'))" | tee -a "$LOG_FILE"
else
  EXIT_CODE=$?
  echo "  ❌ Failed: $TASK ($(date '+%H:%M:%S'))" | tee -a "$LOG_FILE"
fi

echo "" | tee -a "$LOG_FILE"
echo "========================================" | tee -a "$LOG_FILE"
echo "Finished: $(date '+%Y-%m-%d %H:%M:%S')" | tee -a "$LOG_FILE"
echo "========================================" | tee -a "$LOG_FILE"

# remove logs older than 7 days
find "$LOG_DIR" -type f -name "kintaiplus_*.log" -mtime +7 -exec rm {} \;
exit "$EXIT_CODE"
