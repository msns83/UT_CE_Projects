#!/bin/bash

# Shared runtime and measurement helpers for the scenario scripts.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
RESULTS_DIR="$ROOT_DIR/results"
RUN_ID="${UID:-user}"
RUNTIME_DIR="${TMPDIR:-/tmp}/dist-hw3-${RUN_ID}"
GO_CACHE="${TMPDIR:-/tmp}/dist-hw3-go-cache-${RUN_ID}"
REPLICA_BIN="$RUNTIME_DIR/replica"
CLIENT_BIN="$RUNTIME_DIR/client"

mkdir -p "$RESULTS_DIR" "$RUNTIME_DIR"

build_binaries() {
    echo "Building replica and client binaries..."
    (
        cd "$ROOT_DIR" || exit 1
        GOCACHE="$GO_CACHE" go build -buildvcs=false -o "$REPLICA_BIN" ./replica &&
            GOCACHE="$GO_CACHE" go build -buildvcs=false -o "$CLIENT_BIN" ./client
    )
}

replica_port() {
    case "$1" in
        replica1) echo 8001 ;;
        replica2) echo 8002 ;;
        replica3) echo 8003 ;;
        *) return 1 ;;
    esac
}

stop_replica() {
    local id="$1"
    local pid_file="$RESULTS_DIR/${id}.pid"
    local pid command

    if [ ! -f "$pid_file" ]; then
        echo "  $id: no managed process"
        return 0
    fi

    pid="$(sed -n '1p' "$pid_file")"
    if ! [[ "$pid" =~ ^[0-9]+$ ]]; then
        echo "  $id: invalid PID file; no signal sent" >&2
        rm -f "$pid_file"
        return 1
    fi

    command="$(ps -p "$pid" -o command= 2>/dev/null || true)"
    case "$command" in
        "$REPLICA_BIN"*)
            kill "$pid" 2>/dev/null || true
            for _ in $(seq 1 30); do
                if ! kill -0 "$pid" 2>/dev/null; then
                    break
                fi
                sleep 0.1
            done
            if kill -0 "$pid" 2>/dev/null; then
                kill -9 "$pid" 2>/dev/null || true
            fi
            echo "  $id: stopped PID $pid"
            ;;
        "")
            echo "  $id: PID $pid already stopped"
            ;;
        *)
            echo "  $id: PID $pid belongs to another command; no signal sent" >&2
            ;;
    esac

    rm -f "$pid_file"
}

stop_cluster() {
    echo "Stopping managed replicas..."
    stop_replica replica1
    stop_replica replica2
    stop_replica replica3
}

ports_are_free() {
    local port
    if ! command -v lsof >/dev/null 2>&1; then
        return 0
    fi
    for port in 8001 8002 8003; do
        if lsof -nP -iTCP:"$port" -sTCP:LISTEN >/dev/null 2>&1; then
            echo "Port $port is already in use. Stop the existing process before running a scenario." >&2
            return 1
        fi
    done
}

start_cluster() {
    local mode="$1"
    local delay_ms="$2"
    local number id pid port ready health

    if [[ "$mode" != "eventual" && "$mode" != "strong" ]]; then
        echo "Mode must be eventual or strong" >&2
        return 1
    fi
    if ! [[ "$delay_ms" =~ ^[0-9]+$ ]]; then
        echo "Delay must be a non-negative integer" >&2
        return 1
    fi

    stop_cluster >/dev/null 2>&1 || true
    ports_are_free || return 1
    build_binaries || return 1

    echo "Starting three replicas: mode=$mode, replication_delay=${delay_ms}ms"
    for number in 1 2 3; do
        id="replica${number}"
        nohup "$REPLICA_BIN" \
            -config "$ROOT_DIR/configs/${id}.json" \
            -mode "$mode" \
            -delay "$delay_ms" \
            > "$RESULTS_DIR/${id}.log" 2>&1 &
        echo "$!" > "$RESULTS_DIR/${id}.pid"
    done

    for number in 1 2 3; do
        id="replica${number}"
        port="$(replica_port "$id")"
        pid="$(sed -n '1p' "$RESULTS_DIR/${id}.pid")"
        ready=0
        for _ in $(seq 1 50); do
            if ! kill -0 "$pid" 2>/dev/null; then
                break
            fi
            health="$(curl -fsS "http://127.0.0.1:${port}/health" 2>/dev/null || true)"
            if [[ "$health" == *"\"id\":\"${id}\""* && "$health" == *"\"mode\":\"${mode}\""* ]]; then
                ready=1
                break
            fi
            sleep 0.1
        done
        if [ "$ready" -ne 1 ]; then
            echo "$id failed to become healthy. Log:" >&2
            sed -n '1,80p' "$RESULTS_DIR/${id}.log" >&2
            stop_cluster >/dev/null 2>&1 || true
            return 1
        fi
    done

    echo "All replicas are healthy on ports 8001, 8002, and 8003."
}

now_ms() {
    perl -MTime::HiRes=time -e 'printf "%.3f", time() * 1000'
}

milliseconds_between() {
    awk -v start="$1" -v finish="$2" 'BEGIN { printf "%.3f", finish - start }'
}

seconds_to_ms() {
    awk -v seconds="$1" 'BEGIN { printf "%.3f", seconds * 1000 }'
}

average_ms() {
    awk 'BEGIN { sum=0; count=0 } { for (i=1; i<=NF; i++) { sum += $i; count++ } } END { if (count == 0) print "0.000"; else printf "%.3f", sum/count }'
}

measure_put() {
    local port="$1"
    local key="$2"
    local value="$3"
    local response_file="$RUNTIME_DIR/put-response-$$.json"
    local curl_exit=0
    local measurement seconds
    measurement="$(curl -sS --max-time 8 -o "$response_file" \
        -w '%{time_total}\t%{http_code}' \
        -X PUT -H 'Content-Type: application/json' \
        --data "{\"key\":\"${key}\",\"value\":\"${value}\"}" \
        "http://127.0.0.1:${port}/put")" || curl_exit=$?
    IFS=$'\t' read -r seconds MEASURE_STATUS <<< "$measurement"
    MEASURE_MS="$(seconds_to_ms "${seconds:-0}")"
    MEASURE_BODY="$(sed -n '1,20p' "$response_file" 2>/dev/null || true)"
    MEASURE_CURL_EXIT="$curl_exit"
    rm -f "$response_file"
}

measure_get() {
    local port="$1"
    local key="$2"
    local response_file="$RUNTIME_DIR/get-response-$$.json"
    local curl_exit=0
    local measurement seconds
    measurement="$(curl -sS --max-time 8 -o "$response_file" \
        -w '%{time_total}\t%{http_code}' \
        "http://127.0.0.1:${port}/get?key=${key}")" || curl_exit=$?
    IFS=$'\t' read -r seconds MEASURE_STATUS <<< "$measurement"
    MEASURE_MS="$(seconds_to_ms "${seconds:-0}")"
    MEASURE_BODY="$(sed -n '1,20p' "$response_file" 2>/dev/null || true)"
    MEASURE_CURL_EXIT="$curl_exit"
    rm -f "$response_file"
}

body_has_value() {
    local body="$1"
    local expected="$2"
    [[ "$body" == *"\"value\":\"${expected}\""* ]]
}

extract_value() {
    printf '%s' "$1" | sed -n 's/.*"value":"\([^"]*\)".*/\1/p'
}

wait_for_convergence() {
    local key="$1"
    local expected="$2"
    local started_ms="$3"
    shift 3
    local expected_replicas="$#"
    local deadline_ms updated port finished_ms
    deadline_ms="$(awk -v start="$started_ms" 'BEGIN { printf "%.3f", start + 10000 }')"

    while :; do
        updated=0
        for port in "$@"; do
            measure_get "$port" "$key"
            if body_has_value "$MEASURE_BODY" "$expected"; then
                updated=$((updated + 1))
            fi
        done
        finished_ms="$(now_ms)"
        if [ "$updated" -eq "$expected_replicas" ]; then
            CONVERGENCE_MS="$(milliseconds_between "$started_ms" "$finished_ms")"
            UPDATED_REPLICAS="$updated"
            return 0
        fi
        if awk -v now="$finished_ms" -v deadline="$deadline_ms" 'BEGIN { exit !(now >= deadline) }'; then
            CONVERGENCE_MS=">10000"
            UPDATED_REPLICAS="$updated"
            return 1
        fi
        sleep 0.02
    done
}

wait_for_same_value() {
    local key="$1"
    local started_ms="$2"
    shift 2
    local expected_replicas="$#"
    local deadline_ms first_value same updated port value finished_ms
    deadline_ms="$(awk -v start="$started_ms" 'BEGIN { printf "%.3f", start + 10000 }')"

    while :; do
        first_value=""
        same=1
        updated=0
        for port in "$@"; do
            measure_get "$port" "$key"
            value="$(extract_value "$MEASURE_BODY")"
            if [ -z "$value" ]; then
                same=0
                continue
            fi
            updated=$((updated + 1))
            if [ -z "$first_value" ]; then
                first_value="$value"
            elif [ "$value" != "$first_value" ]; then
                same=0
            fi
        done
        finished_ms="$(now_ms)"
        if [ "$same" -eq 1 ] && [ "$updated" -eq "$expected_replicas" ]; then
            CONVERGENCE_MS="$(milliseconds_between "$started_ms" "$finished_ms")"
            UPDATED_REPLICAS="$updated"
            CONVERGED_VALUE="$first_value"
            return 0
        fi
        if awk -v now="$finished_ms" -v deadline="$deadline_ms" 'BEGIN { exit !(now >= deadline) }'; then
            CONVERGENCE_MS=">10000"
            UPDATED_REPLICAS="$updated"
            CONVERGED_VALUE="not-converged"
            return 1
        fi
        sleep 0.02
    done
}

append_metric() {
    local fragment="$1"
    shift
    printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "$@" >> "$RESULTS_DIR/$fragment"
}

rebuild_metrics_file() {
    local temp_file="$RESULTS_DIR/metrics.txt.tmp"
    local file scenario model delay put_value get_value convergence stale updated outcome
    {
        echo "=== Measured Metrics from Scenario Executions ==="
        echo
        echo "Generated: $(date '+%Y-%m-%d %H:%M:%S %Z')"
        echo "Latencies and convergence times are measured end-to-end from the scenario runner."
        echo
        echo "| Scenario | Model | Delay | PUT Latency (ms) | GET Latency (ms) | Convergence (ms) | Stale Reads | Updated Replicas | Outcome |"
        echo "|----------|-------|-------|------------------|------------------|------------------|-------------|------------------|---------|"
        for file in "$RESULTS_DIR"/metric_scenario*.tsv; do
            [ -f "$file" ] || continue
            while IFS=$'\t' read -r scenario model delay put_value get_value convergence stale updated outcome; do
                printf '| %s | %s | %s | %s | %s | %s | %s | %s | %s |\n' \
                    "$scenario" "$model" "$delay" "$put_value" "$get_value" \
                    "$convergence" "$stale" "$updated" "$outcome"
            done < "$file"
        done
        echo
        echo "Notes:"
        echo "- PUT/GET latency is HTTP round-trip time measured by curl, without Go compilation time."
        echo "- Convergence is measured from the start of PUT until all expected live replicas return the target value."
        echo "- Stale Reads counts the explicit immediate reads in each scenario that returned missing/older data."
        echo "- Values vary slightly between runs because of OS scheduling and machine load."
    } > "$temp_file"
    mv "$temp_file" "$RESULTS_DIR/metrics.txt"
}
