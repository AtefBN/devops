# Imports.
source "$INSTALLER_HOME/sh/constants.sh"
source "$INSTALLER_SHARED/sh/utils.sh"

# Main entry point.
main()
{
    log "BEGIN step 6:"

    log "... step 6.1: initialising DB"
    _init_db

    log "... step 6.2: creating DB schema + tables"
    pushd "$HOME/esdoc-errata-ws"
    uv run python "$INSTALLER_HOME/sh/step_06.py"
    popd

    log "END step 6"
}

# Initialises application database.
function _init_db() {
    # Ensure PostgreSQL is running (handles versioned service names like postgresql-17)
    local PG_SERVICE
    PG_SERVICE=$(sudo systemctl list-units --type=service --no-pager | grep -E '^postgresql' | head -n1 | awk '{print $1}')
    
    if [[ -n "$PG_SERVICE" ]]; then
        if ! sudo systemctl is-active --quiet "$PG_SERVICE"; then
            log "Starting PostgreSQL service: $PG_SERVICE"
            sudo systemctl start "$PG_SERVICE"
        fi
    else
        log_error "PostgreSQL service not found. Install PostgreSQL first."
        return 1
    fi

    # Create db objects (ignore if already exists)
    if ! sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='esdoc'" | grep -q 1; then
        sudo -u postgres createuser esdoc
    fi

    if ! sudo -u postgres psql -tAc "SELECT 1 FROM pg_database WHERE datname='esdoc_errata'" | grep -q 1; then
        sudo -u postgres createdb -O esdoc esdoc_errata
    fi

    # Set db credentials
    local TMP_DIR="$HOME/.esdoc/tmp"
    mkdir -p "$TMP_DIR"

    cat >> "$TMP_DIR/creds.sql" <<- EOM
ALTER USER esdoc WITH PASSWORD '$ERRATA_DB_PWD';
EOM
    sudo -u postgres psql -d esdoc_errata -q -f "$TMP_DIR/creds.sql"
    rm "$TMP_DIR/creds.sql"
}

# Invoke entry point.
main