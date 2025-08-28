#/bin/bash
ARGS=""

[[ $INPUT_FAIL_ON_WARN == "true" ]] && ARGS+=" --fail-on-warn"

/zed validate $ARGS $INPUT_VALIDATIONFILE
