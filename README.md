# Bash Client Example

This directory demonstrates a minimal Kuberhealthy check written in Bash.

The reusable [`kuberhealthy-client.sh`](kuberhealthy-client.sh) library exposes helper functions for reporting results. The [`check.sh`](check.sh) example sources the library, reads the Kuberhealthy run UUID and reporting URL from the `KH_RUN_UUID` and `KH_REPORTING_URL` environment variables that Kuberhealthy sets on checker pods, and then reports success or failure back to Kuberhealthy.

## Using the example

1. **Add your logic** – Replace the placeholder section in `check.sh` with commands that verify the condition you care about. Call `kh::report_success` when the check passes or `kh::report_failure "message"` when it fails.
2. **Build the image** – Build a container that runs the script:

   ```sh
   make build IMAGE=your-registry/bash-check TAG=v1
   ```

3. **Push the image** – Push the image to a registry accessible by your cluster:

   ```sh
   make push IMAGE=your-registry/bash-check TAG=v1
   ```

4. **Create a KuberhealthyCheck** – Reference the image in a `KuberhealthyCheck` resource and apply it to your cluster:

   ```yaml
   apiVersion: kuberhealthy.github.io/v2
   kind: KuberhealthyCheck
   metadata:
     name: bash-example
     namespace: kuberhealthy
   spec:
     runInterval: 1m
     podSpec:
       containers:
       - name: bash
         image: your-registry/bash-check:v1
         imagePullPolicy: IfNotPresent
   ```

When the pod runs, `check.sh` will report its result to Kuberhealthy. Set the `FAIL=true` environment variable to simulate a failure.

## Using the client library in your own scripts

Copy `kuberhealthy-client.sh` into your repository and source it from your Kuberhealthy check scripts:

```bash
#!/usr/bin/env bash
set -euo pipefail
source "kuberhealthy-client.sh"
kh::init

if my_check_logic; then
  kh::report_success
else
  kh::report_failure "something went wrong"
fi
```
