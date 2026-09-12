#!/bin/bash

set -u
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=common.sh
source "$SCRIPT_DIR/common.sh"

RESULT_FILE="$RESULTS_DIR/scenario4.txt"
METRIC_FRAGMENT="metric_scenario4.tsv"
: > "$RESULTS_DIR/$METRIC_FRAGMENT"

cleanup() {
    stop_cluster
}
trap cleanup EXIT INT TERM
exec > >(tee "$RESULT_FILE") 2>&1

echo "=========================================="
echo "Scenario 4: Network Delay"
echo "=========================================="
echo "Purpose: measure how 0ms, 500ms, and 2000ms delays affect eventual convergence."
echo

run_eventual_case() {
    delay_ms="$1"
    scenario_label="$2"
    key="delay_${delay_ms}"
    value="value_${delay_ms}"

    echo "--- Eventual consistency, ${delay_ms}ms delay ---"
    start_cluster eventual "$delay_ms" || return 1

    started_ms="$(now_ms)"
    measure_put 8001 "$key" "$value"
    put_ms="$MEASURE_MS"
    echo "PUT replica1: HTTP $MEASURE_STATUS, ${put_ms}ms, response=$MEASURE_BODY"

    measure_get 8002 "$key"
    immediate_get_ms="$MEASURE_MS"
    stale_reads=0
    if body_has_value "$MEASURE_BODY" "$value"; then
        echo "Immediate GET replica2: fresh, ${MEASURE_MS}ms, response=$MEASURE_BODY"
    else
        stale_reads=1
        echo "Immediate GET replica2: STALE, ${MEASURE_MS}ms, response=$MEASURE_BODY"
    fi

    wait_for_convergence "$key" "$value" "$started_ms" 8001 8002 8003 || true
    echo "Convergence: ${CONVERGENCE_MS}ms; updated replicas=$UPDATED_REPLICAS."

    measure_get 8002 "$key"
    final_get_ms="$MEASURE_MS"
    echo "Final GET replica2: ${MEASURE_MS}ms, response=$MEASURE_BODY"
    get_average_ms="$(printf '%s\n%s\n' "$immediate_get_ms" "$final_get_ms" | average_ms)"

    append_metric "$METRIC_FRAGMENT" \
        "$scenario_label" "Eventual" "${delay_ms}ms" "$put_ms" "$get_average_ms" \
        "$CONVERGENCE_MS" "$stale_reads" "$UPDATED_REPLICAS" "Converged to $value"

    stop_cluster
    echo
}

run_eventual_case 0 "4A"
run_eventual_case 500 "4B"
run_eventual_case 2000 "4C"

echo "--- Strong consistency comparison, 0ms delay ---"
start_cluster strong 0 || exit 1
started_ms="$(now_ms)"
measure_put 8001 strong_delay strong_value
strong_put_ms="$MEASURE_MS"
echo "PUT replica1: HTTP $MEASURE_STATUS, ${strong_put_ms}ms, response=$MEASURE_BODY"

measure_get 8002 strong_delay
strong_get_ms="$MEASURE_MS"
strong_stale=0
if body_has_value "$MEASURE_BODY" strong_value; then
    echo "Immediate GET replica2: fresh, ${MEASURE_MS}ms, response=$MEASURE_BODY"
else
    strong_stale=1
    echo "Immediate GET replica2: STALE, ${MEASURE_MS}ms, response=$MEASURE_BODY"
fi

wait_for_convergence strong_delay strong_value "$started_ms" 8001 8002 8003 || true
echo "Convergence: ${CONVERGENCE_MS}ms; updated replicas=$UPDATED_REPLICAS."

append_metric "$METRIC_FRAGMENT" \
    "4D" "Strong" "0ms" "$strong_put_ms" "$strong_get_ms" \
    "$CONVERGENCE_MS" "$strong_stale" "$UPDATED_REPLICAS" "Synchronous write completed"

rebuild_metrics_file
echo
echo "Results saved to $RESULT_FILE"
echo "Metrics updated in $RESULTS_DIR/metrics.txt"

cleanup
trap - EXIT INT TERM
