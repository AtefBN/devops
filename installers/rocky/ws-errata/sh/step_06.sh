# Imports.
source "$INSTALLER_HOME/sh/constants.sh"
source /opt/esgf/devops/installers/ubuntu/shared/sh/utils.sh

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
    # Create db objects.
    sudo -u postgres createuser esdoc
    sudo -u postgres createdb -O esdoc esdoc_errata

    # Set db credentials.
    local TMP_DIR="$HOME/.esdoc/tmp"
    mkdir -p "$TMP_DIR"

    cat >> "$TMP_DIR/creds.sql" <<- EOM
ALTER USER $ERRATA_DB_USER PASSWORD '$ERRATA_DB_PWD';
EOM
    sudo -u postgres psql -d "$ERRATA_DB_NAME" -q -f "$TMP_DIR/creds.sql"
    rm "$TMP_DIR/creds.sql"
}

# Invoke entry point.
main