#!/usr/bin/env bash
# Helper functions for reporting results to Kuberhealthy from bash checks.
# Source this file in your check script and call kh::init before reporting results.

kh::init() {
  UUID="${KH_RUN_UUID:-}"
  REPORT_URL="${KH_REPORTING_URL:-}"
  if [[ -z "$UUID" || -z "$REPORT_URL" ]]; then
    echo "KH_RUN_UUID and KH_REPORTING_URL must be set" >&2
    return 1
  fi
}

kh::report_success() {
  curl -sS -X POST \
    -H "Content-Type: application/json" \
    -H "kh-run-uuid: ${UUID}" \
    -d '{"ok":true,"errors":[]}' \
    "${REPORT_URL}"
}

kh::report_failure() {
  local msg="$1"
  curl -sS -X POST \
    -H "Content-Type: application/json" \
    -H "kh-run-uuid: ${UUID}" \
    -d '{"ok":false,"errors":["'"${msg}"'"]}' \
    "${REPORT_URL}"
}

