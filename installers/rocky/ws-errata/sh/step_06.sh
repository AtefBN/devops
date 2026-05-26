#!/usr/bin/env bash

# Imports.
source "$INSTALLER_SHARED/sh/utils.sh"
source "$INSTALLER_SHARED/sh/constants.sh"
source "$INSTALLER_SHARED/sh/init_python.sh"

# Initialises application database.
function _init_db() {
    # Create db objects.
    sudo -i -u postgres createuser "$ERRATA_DB_USER"
    sudo -i -u postgres createdb -O "$ERRATA_DB_USER" "$ERRATA_DB_NAME"

    # Set db credentials.
    if [[ ! -d $HOME/devops/tmp ]]; then
        mkdir -p $HOME/devops/tmp
    fi
    cat >> $HOME/devops/tmp/creds.sql <<- EOM
ALTER USER $ERRATA_DB_USER PASSWORD '$ERRATA_DB_PWD';
EOM
    sudo -i -u postgres psql -d "$ERRATA_DB_NAME" -q -f $HOME/devops/tmp/creds.sql
    rm $HOME/devops/tmp/creds.sql
}

# Main entry point.
main()
{
    log "BEGIN step 6:"

    # Fixed paths
    local PROJECT_DIR="$HOME/opt/errata-ws"
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

    # Initialize DB
    log "... step 6.2.5: initializing DB"
    _init_db

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