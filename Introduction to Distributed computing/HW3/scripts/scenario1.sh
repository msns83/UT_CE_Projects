#!/bin/bash

set -u
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=common.sh
source "$SCRIPT_DIR/common.sh"

RESULT_FILE="$RESULTS_DIR/scenario1.txt"
METRIC_FRAGMENT="metric_scenario1.tsv"
: > "$RESULTS_DIR/$METRIC_FRAGMENT"

cleanup() {
    stop_cluster
}
trap cleanup EXIT INT TERM
exec > >(tee "$RESULT_FILE") 2>&1

echo "=========================================="
echo "Scenario 1: Temporary Inconsistency"
echo "=========================================="
echo "Purpose: show a stale read followed by convergence in eventual mode."
echo

start_cluster eventual 500 || exit 1

started_ms="$(now_ms)"
measure_put 8001 x 10
put_ms="$MEASURE_MS"
echo "PUT replica1: HTTP $MEASURE_STATUS, ${put_ms}ms, response=$MEASURE_BODY"

measure_get 8002 x
initial_get_ms="$MEASURE_MS"
initial_body="$MEASURE_BODY"
stale_reads=0
if body_has_value "$initial_body" 10; then
    echo "Immediate GET replica2: fresh, ${initial_get_ms}ms, response=$initial_body"
else
    stale_reads=1
    echo "Immediate GET replica2: STALE, ${initial_get_ms}ms, response=$initial_body"
fi

if wait_for_convergence x 10 "$started_ms" 8001 8002 8003; then
    echo "All replicas converged after ${CONVERGENCE_MS}ms."
else
    echo "Convergence timed out after 10 seconds."
fi

get_latencies="$initial_get_ms"
for port in 8001 8002 8003; do
    measure_get "$port" x
    echo "Final GET replica$((port - 8000)): ${MEASURE_MS}ms, response=$MEASURE_BODY"
    get_latencies="$get_latencies $MEASURE_MS"
done
get_average_ms="$(printf '%s\n' "$get_latencies" | average_ms)"

append_metric "$METRIC_FRAGMENT" \
    "1" "Eventual" "500ms" "$put_ms" "$get_average_ms" \
    "$CONVERGENCE_MS" "$stale_reads" "$UPDATED_REPLICAS" "Converged to x=10"
rebuild_metrics_file

echo
echo "Measured summary: PUT=${put_ms}ms, average GET=${get_average_ms}ms, convergence=${CONVERGENCE_MS}ms, stale reads=$stale_reads."
echo "Results saved to $RESULT_FILE"
echo "Metrics updated in $RESULTS_DIR/metrics.txt"

cleanup
trap - EXIT INT TERM
