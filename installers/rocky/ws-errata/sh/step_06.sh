#!/usr/bin/env bash

# Imports.
source "$INSTALLER_SHARED/sh/utils.sh"
source "$INSTALLER_SHARED/sh/constants.sh"
source "$INSTALLER_SHARED/sh/init_python.sh"

# Main entry point.
main()
{
    log "BEGIN step 6:"

    # Fixed paths
    local PROJECT_DIR="$HOME/opt/esdoc-errata-ws"
    local VENV_PATH="$PROJECT_DIR/.venv"

    # Check PostgreSQL
    log "... step 6.1: checking PostgreSQL service"
    if ! systemctl is-active --quiet postgresql-17; then
        log_error "PostgreSQL 17 service not running."
        return 1
    fi

    # Set DB environment
    log "... step 6.2: setting DB environment"
    export ERRATA_DB_USER=esdoc
    export ERRATA_DB_NAME=esdoc_errata
    export ERRATA_DB_PWD="${ERRATA_DB_PASS:-esdoc}"

    # Run Python setup
    log "... step 6.3: running Python DB setup"
    pushd "$PROJECT_DIR" >/dev/null
    export PYTHONPATH="$PROJECT_DIR:$PYTHONPATH"
    source "$VENV_PATH/bin/activate"
    python "$INSTALLER_HOME/sh/step_06.py"
    popd >/dev/null

    log "END step 6"
}

# Invoke entry point.
main