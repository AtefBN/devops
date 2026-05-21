function _init_db() {
    # Ensure PostgreSQL is running
    if ! sudo systemctl is-active --quiet postgresql; then
        log "Starting PostgreSQL service..."
        sudo systemctl start postgresql
    fi

    # Create user if not exists
    if ! sudo -u postgres psql -lqt | cut -d \| -f 1 | grep -qw "esdoc"; then
        sudo -u postgres createuser esdoc
    fi

    # Create database if not exists
    if ! sudo -u postgres psql -lqt | cut -d \| -f 1 | grep -qw "esdoc_errata"; then
        sudo -u postgres createdb -O esdoc esdoc_errata
    fi

    # Set credentials (always update password)
    local TMP_DIR="$HOME/.esdoc/tmp"
    mkdir -p "$TMP_DIR"

    cat >> "$TMP_DIR/creds.sql" <<- EOM
ALTER USER esdoc WITH PASSWORD '$ERRATA_DB_PWD';
EOM
    sudo -u postgres psql -d esdoc_errata -q -f "$TMP_DIR/creds.sql"
    rm "$TMP_DIR/creds.sql"
}