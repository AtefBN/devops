# Imports.
source "$INSTALLER_SHARED/sh/utils.sh"
source "$INSTALLER_SHARED/sh/init_python.sh"

# Main entry point.
main()
{
    log "BEGIN step 5:"

    log "... step 5.1: initialising uv virtual environment"

    # Create venv INSIDE the project directory
    local PROJECT_DIR="$HOME/opt/errata-ws"
    local VENV_PATH="$PROJECT_DIR/.venv"

    uv venv --python 3.12 "$VENV_PATH"
    source "$VENV_PATH/bin/activate"

    # Sync dependencies
    if [[ -f "$INSTALLER_HOME/pyproject.toml" ]]; then
        uv pip sync "$INSTALLER_HOME/pyproject.toml"
    else
        log_error "No pyproject.toml found in $INSTALLER_HOME"
        return 1
    fi
    # Initialize esgvoc vocabularies
    log "... step 5.2: initializing esgvoc vocabularies"
    esgvoc use universe@latest
    esgvoc use cmip7@latest
    esgvoc use cmip6@latest
    esgvoc use cordex-cmip5@latest
    esgvoc use cordex-cmip6@latest
    esgvoc use input4mips@latest
    log "END step 5"
}

# Invoke entry point.
main