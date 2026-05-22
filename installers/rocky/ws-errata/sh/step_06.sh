#!/usr/bin/env bash

# Imports.
source "$INSTALLER_SHARED/sh/utils.sh"
source "$INSTALLER_SHARED/sh/constants.sh"
source "$INSTALLER_SHARED/sh/init_python.sh"

# Main entry point.
main()
{
    log "BEGIN step 6:"

    # ---- Step 6.0: Navigate to Python code directory ----
    pushd "$HOME/opt/esdoc-errata-ws"

    # ---- Step 6.1: Check PostgreSQL ----
    log "... step 6.1: checking PostgreSQL service"
    if ! systemctl is-active --quiet postgresql-17; then
        log_error "PostgreSQL 17 service not running."
        popd
        return 1
    fi

    # ---- Step 6.2: Set Environment ----
    log "... step 6.2: setting DB environment"
    export ERRATA_DB_USER=esdoc
    export ERRATA_DB_NAME=esdoc_errata
    export ERRATA_DB_PWD="${ERRATA_DB_PASS:-esdoc}"

    # ---- Step 6.3: Activate venv and run Python DB setup ----
    log "... step 6.3: running Python DB setup"
    source .venv/bin/activate
    python "$INSTALLER_HOME/sh/step_06.py"

    popd
    log "END step 6"
}

# Invoke entry point.
main