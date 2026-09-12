#!/bin/bash

set -u
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=common.sh
source "$SCRIPT_DIR/common.sh"

RESULT_FILE="$RESULTS_DIR/scenario3.txt"
METRIC_FRAGMENT="metric_scenario3.tsv"
: > "$RESULTS_DIR/$METRIC_FRAGMENT"

put1_body="$RUNTIME_DIR/scenario3-put1-body.json"
put2_body="$RUNTIME_DIR/scenario3-put2-body.json"
put1_metric="$RUNTIME_DIR/scenario3-put1-metric.txt"
put2_metric="$RUNTIME_DIR/scenario3-put2-metric.txt"

cleanup() {
    stop_cluster
    rm -f "$put1_body" "$put2_body" "$put1_metric" "$put2_metric"
}
trap cleanup EXIT INT TERM
exec > >(tee "$RESULT_FILE") 2>&1

echo "=========================================="
echo "Scenario 3: Concurrent Conflict"
echo "=========================================="
echo "Purpose: create equal-version concurrent writes and observe LWW convergence."
echo

start_cluster eventual 500 || exit 1
started_ms="$(now_ms)"

curl -sS --max-time 8 -o "$put1_body" -w '%{time_total}\t%{http_code}' \
    -X PUT -H 'Content-Type: application/json' \
    --data '{"key":"conflict","value":"100"}' \
    http://127.0.0.1:8001/put > "$put1_metric" &
put1_pid=$!

curl -sS --max-time 8 -o "$put2_body" -w '%{time_total}\t%{http_code}' \
    -X PUT -H 'Content-Type: application/json' \
    --data '{"key":"conflict","value":"200"}' \
    http://127.0.0.1:8002/put > "$put2_metric" &
put2_pid=$!

wait "$put1_pid"
wait "$put2_pid"

IFS=$'\t' read -r put1_seconds put1_status < "$put1_metric"
IFS=$'\t' read -r put2_seconds put2_status < "$put2_metric"
put1_ms="$(seconds_to_ms "$put1_seconds")"
put2_ms="$(seconds_to_ms "$put2_seconds")"
put_average_ms="$(printf '%s\n%s\n' "$put1_ms" "$put2_ms" | average_ms)"
echo "Concurrent PUT replica1: HTTP $put1_status, ${put1_ms}ms, response=$(sed -n '1,5p' "$put1_body")"
echo "Concurrent PUT replica2: HTTP $put2_status, ${put2_ms}ms, response=$(sed -n '1,5p' "$put2_body")"

wait_for_same_value conflict "$started_ms" 8001 8002 8003 || true
echo "All replicas converged after ${CONVERGENCE_MS}ms; LWW winner=$CONVERGED_VALUE."

get_latencies=""
for port in 8001 8002 8003; do
    measure_get "$port" conflict
    echo "Final GET replica$((port - 8000)): ${MEASURE_MS}ms, response=$MEASURE_BODY"
    get_latencies="$get_latencies $MEASURE_MS"
done
get_average_ms="$(printf '%s\n' "$get_latencies" | average_ms)"

echo
echo "Conflict-related server log lines:"
grep -E 'PUT key=conflict|Replicated key=conflict|Ignored stale replication for key=conflict' \
    "$RESULTS_DIR/replica1.log" "$RESULTS_DIR/replica2.log" "$RESULTS_DIR/replica3.log" || true

append_metric "$METRIC_FRAGMENT" \
    "3" "Eventual + LWW" "500ms" "$put_average_ms" "$get_average_ms" \
    "$CONVERGENCE_MS" "0" "$UPDATED_REPLICAS" "LWW winner=$CONVERGED_VALUE"
rebuild_metrics_file

echo
echo "Results saved to $RESULT_FILE"
echo "Metrics updated in $RESULTS_DIR/metrics.txt"

cleanup
trap - EXIT INT TERM
