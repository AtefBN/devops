# Imports.
source "$INSTALLER_SHARED/sh/utils.sh"
source "$INSTALLER_SHARED/sh/init_python.sh"

# Main entry point.
main()
{
    log "BEGIN step 5:"

    log "... step 5.1: initialising uv virtual environment"

    # Create and activate virtual environment
    uv venv
    source .venv/bin/activate

    # Sync dependencies from requirements.txt or pyproject.toml
    if [[ -f "$INSTALLER_HOME/requirements.txt" ]]; then
        uv pip sync "$INSTALLER_HOME/requirements.txt"
    elif [[ -f "$INSTALLER_HOME/pyproject.toml" ]]; then
        uv pip sync "$INSTALLER_HOME/pyproject.toml"
    else
        log_error "No requirements.txt or pyproject.toml found in $INSTALLER_HOME"
        return 1
    fi

    log "END step 5"
}

# Invoke entry point.
main