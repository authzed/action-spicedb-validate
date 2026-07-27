#!/bin/bash
set -e

# Enable recursive globbing for ** patterns (bash 4+)
# Guard for bash 3.x compatibility (e.g., macOS default)
shopt -s nullglob
shopt -s globstar 2>/dev/null || true

ARGS=""
[[ $INPUT_FAIL_ON_WARN == "true" ]] && ARGS+=" --fail-on-warn"

# Collect all files to validate
FILES=()
HAD_INPUT=0

# Handle single file input (backward compatibility)
if [[ -n "$INPUT_VALIDATIONFILE" ]]; then
    HAD_INPUT=1
    FILES+=("$INPUT_VALIDATIONFILE")
fi

# Handle multiple files input
if [[ -n "$INPUT_VALIDATIONFILES" ]]; then
    HAD_INPUT=1
    # Replace commas with newlines and process each entry
    # Use printf instead of echo to avoid option interpretation
    while IFS= read -r entry; do
        # Trim leading/trailing whitespace without breaking spaces in paths
        entry="${entry#"${entry%%[![:space:]]*}"}"
        entry="${entry%"${entry##*[![:space:]]}"}"
        [[ -z "$entry" ]] && continue
        
        # Check if entry contains glob pattern characters
        if [[ "$entry" == *"*"* || "$entry" == *"?"* || "$entry" == *"["* ]]; then
            # Expand glob pattern safely without eval (globstar enabled for ** support)
            # Use an array assignment for safe glob expansion
            expanded=()
            # shellcheck disable=SC2206
            expanded=($entry)
            for file in "${expanded[@]}"; do
                [[ -f "$file" ]] && FILES+=("$file")
            done
        else
            FILES+=("$entry")
        fi
    done <<< "$(printf '%s\n' "$INPUT_VALIDATIONFILES" | tr ',' '\n')"
fi

# Check if we have any files to validate
if [[ $HAD_INPUT -eq 0 ]]; then
    echo "Error: No validation files provided. Set either 'validationfile' or 'validationfiles' input."
    exit 1
fi

if [[ ${#FILES[@]} -eq 0 ]]; then
    echo "Error: No files matched the provided patterns."
    exit 1
fi

# Validate each file
FAILED=0
for file in "${FILES[@]}"; do
    echo "Validating $file..."
    # ARGS is intentionally unquoted for word splitting (may be empty or --fail-on-warn)
    # Use -- to prevent filenames starting with - from being interpreted as options
    # shellcheck disable=SC2086
    if ! /zed validate $ARGS -- "$file"; then
        FAILED=1
    fi
done

exit $FAILED
