# Imports.
source "$INSTALLER_SHARED/sh/utils.sh"
source "$INSTALLER_SHARED/sh/init_python.sh"

# Minimum required Python version
MIN_PYTHON_VERSION="3.9"

# Main entry point.
main()
{
    log "BEGIN step 3:"

    log "... step 3.1: verifying python"

    # Get Python version
    PYTHON_VERSION=$(uv run python --version 2>&1 | awk '{print $2}' | cut -d. -f1-2)

    log "Detected Python version: $PYTHON_VERSION"

    # Compare versions
    if [[ "$PYTHON_VERSION" < "$MIN_PYTHON_VERSION" ]]; then
        log_error "Python $MIN_PYTHON_VERSION+ is required, but found $PYTHON_VERSION"
        return 1
    fi

    log "... Python version is valid ($PYTHON_VERSION >= $MIN_PYTHON_VERSION)"
    log "END step 3"
}

# Invoke entry point.
main