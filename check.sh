#!/usr/bin/env bash
set -euo pipefail

# Source the Kuberhealthy client library and initialize it.
source "$(dirname "$0")/kuberhealthy-client.sh"
kh::init

# Add your check logic here. For example purposes, this check reports success
# unless the FAIL environment variable is set to "true".
if [[ "${FAIL:-}" == "true" ]]; then
  kh::report_failure "FAIL was set to true"
else
  kh::report_success
fi
