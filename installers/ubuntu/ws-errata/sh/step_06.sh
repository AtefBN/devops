#!/usr/bin/env bash

# Imports.
source "$INSTALLER_SHARED/sh/utils.sh"
source "$INSTALLER_SHARED/sh/constants.sh"
source "$INSTALLER_SHARED/sh/init_python.sh"

# Main entry point.
main()
{
    log "BEGIN step 6:"

    # ---- Step 6.1: Check PostgreSQL ----
    log "... step 6.1: checking PostgreSQL service"
    if ! systemctl is-active --quiet postgresql-17; then
        log_error "PostgreSQL 17 service not running."
        log_error "Start it with: sudo systemctl start postgresql-17"
        return 1
    fi

    # ---- Step 6.2: Create DB and User (from app_environment.txt) ----
    log "... step 6.2: creating database and user"
    local DB_NAME="esdoc_errata"
    local DB_USER="esdoc"
    local DB_PASS="${ERRATA_DB_PASS:-esdoc}"  # Uses env var or defaults to 'esdoc'

    # Check if user exists, create if not
    if ! sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='$DB_USER'" | grep -q 1; then
        sudo -u postgres psql -c "CREATE USER $DB_USER WITH PASSWORD '$DB_PASS';"
    fi

    # Check if database exists, create if not
    if ! sudo -u postgres psql -tAc "SELECT 1 FROM pg_database WHERE datname='$DB_NAME'" | grep -q 1; then
        sudo -u postgres createdb -O $DB_USER $DB_NAME
    fi

    # ---- Step 6.3: Initialize Schema ----
    log "... step 6.3: initializing DB schema"
    if [[ -f "$INSTALLER_HOME/sql/schema.sql" ]]; then
        PGPASSWORD="$DB_PASS" psql -U $DB_USER -d $DB_NAME -f "$INSTALLER_HOME/sql/schema.sql"
    else
        log_error "Schema file not found at $INSTALLER_HOME/sql/schema.sql"
        return 1
    fi

    log "END step 6"
}

# Invoke entry point.
main