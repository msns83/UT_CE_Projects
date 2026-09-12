#!/bin/bash

set -u
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=common.sh
source "$SCRIPT_DIR/common.sh"

RESULT_FILE="$RESULTS_DIR/scenario2.txt"
METRIC_FRAGMENT="metric_scenario2.tsv"
: > "$RESULTS_DIR/$METRIC_FRAGMENT"

cleanup() {
    stop_cluster
}
trap cleanup EXIT INT TERM
exec > >(tee "$RESULT_FILE") 2>&1

echo "=========================================="
echo "Scenario 2: Replica Failure"
echo "=========================================="
echo "Purpose: compare eventual and strong writes while replicas fail."
echo

echo "--- Part A: Eventual consistency with replica3 down ---"
start_cluster eventual 0 || exit 1
stop_replica replica3

started_ms="$(now_ms)"
measure_put 8001 failure_eventual 20
eventual_put_ms="$MEASURE_MS"
eventual_put_body="$MEASURE_BODY"
echo "PUT replica1: HTTP $MEASURE_STATUS, ${eventual_put_ms}ms, response=$eventual_put_body"

measure_get 8002 failure_eventual
eventual_initial_get_ms="$MEASURE_MS"
eventual_stale=0
if body_has_value "$MEASURE_BODY" 20; then
    echo "Immediate GET replica2: fresh, ${MEASURE_MS}ms, response=$MEASURE_BODY"
else
    eventual_stale=1
    echo "Immediate GET replica2: STALE, ${MEASURE_MS}ms, response=$MEASURE_BODY"
fi

wait_for_convergence failure_eventual 20 "$started_ms" 8001 8002 || true
measure_get 8002 failure_eventual
eventual_final_get_ms="$MEASURE_MS"
echo "Final GET replica2: ${MEASURE_MS}ms, response=$MEASURE_BODY"
eventual_get_average="$(printf '%s\n%s\n' "$eventual_initial_get_ms" "$eventual_final_get_ms" | average_ms)"

append_metric "$METRIC_FRAGMENT" \
    "2A" "Eventual" "0ms" "$eventual_put_ms" "$eventual_get_average" \
    "$CONVERGENCE_MS" "$eventual_stale" "$UPDATED_REPLICAS" "PUT succeeded with replica3 down"

stop_cluster
echo
echo "--- Part B: Strong consistency with replica3 down ---"
start_cluster strong 0 || exit 1
stop_replica replica3

started_ms="$(now_ms)"
measure_put 8001 failure_strong 30
strong_put_ms="$MEASURE_MS"
strong_put_body="$MEASURE_BODY"
echo "PUT replica1: HTTP $MEASURE_STATUS, ${strong_put_ms}ms, response=$strong_put_body"

wait_for_convergence failure_strong 30 "$started_ms" 8001 8002 || true
strong_get_latencies=""
for port in 8001 8002; do
    measure_get "$port" failure_strong
    echo "GET replica$((port - 8000)): ${MEASURE_MS}ms, response=$MEASURE_BODY"
    strong_get_latencies="$strong_get_latencies $MEASURE_MS"
done
strong_get_average="$(printf '%s\n' "$strong_get_latencies" | average_ms)"

append_metric "$METRIC_FRAGMENT" \
    "2B" "Strong" "0ms" "$strong_put_ms" "$strong_get_average" \
    "$CONVERGENCE_MS" "0" "$UPDATED_REPLICAS" "PUT succeeded with 2-of-3 majority"

echo
echo "--- Part C: Strong consistency without a majority ---"
stop_replica replica2
measure_put 8001 no_majority 40
no_majority_put_ms="$MEASURE_MS"
echo "PUT replica1: HTTP $MEASURE_STATUS, ${no_majority_put_ms}ms, response=$MEASURE_BODY"

append_metric "$METRIC_FRAGMENT" \
    "2C" "Strong" "0ms" "$no_majority_put_ms" "N/A" \
    "N/A" "0" "0" "PUT rejected without majority (HTTP $MEASURE_STATUS)"

rebuild_metrics_file
echo
echo "Results saved to $RESULT_FILE"
echo "Metrics updated in $RESULTS_DIR/metrics.txt"

cleanup
trap - EXIT INT TERM
