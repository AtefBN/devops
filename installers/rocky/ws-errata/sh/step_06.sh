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

    # ---- Step 6.2: Create DB and User ----
    log "... step 6.2: creating database and user"
    local DB_NAME="esgf_errata"
    local DB_USER="esgf"
    local DB_PASS="esgf"

    # Check if user exists, create if not
    if ! sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='$DB_USER'" | grep -q 1; then
        sudo -u postgres createuser -P $DB_USER
    fi

    # Check if database exists, create if not
    if ! sudo -u postgres psql -tAc "SELECT 1 FROM pg_database WHERE datname='$DB_NAME'" | grep -q 1; then
        sudo -u postgres createdb -O $DB_USER $DB_NAME
    fi

    # ---- Step 6.3: Initialize Schema ----
    log "... step 6.3: initializing DB schema"
    if [[ -f "$INSTALLER_HOME/sql/schema.sql" ]]; then
        sudo -u postgres psql -d $DB_NAME -f "$INSTALLER_HOME/sql/schema.sql"
    else
        log_error "Schema file not found at $INSTALLER_HOME/sql/schema.sql"
        return 1
    fi

    log "END step 6"
}

# Invoke entry point.
main