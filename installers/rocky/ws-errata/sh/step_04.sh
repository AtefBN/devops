# Imports.
source "$INSTALLER_HOME/sh/constants.sh"
source "$INSTALLER_SHARED/sh/init_stack.sh"
source "$INSTALLER_SHARED/sh/utils.sh"

# Main entry point.
main()
{
    log "BEGIN step 4:"

    log "... step 4.1: initialising repos"
    for REPO in "${INSTALLER_REPOS[@]}"
    do
        init_stack_repo "$REPO"
    done

    log "... step 4.2: initialising environment"
    init_stack_env "$INSTALLER_HOME"

    log "... step 4.3: initialising credentials"
    _init_credentials

    log "... step 4.4: initialising ops directories"
    _install_ops

    log "END step 4"
}

# Initialises application credentials.
function _init_credentials() {
    # Use user's home directory
    local TMP_DIR="$HOME/.esdoc/tmp"
    mkdir -p "$TMP_DIR"

    cat >> "$HOME/.esdoc/credentials" <<- EOM

# Errata database password.
export ERRATA_DB_PWD=$(openssl rand -hex 16)

EOM
    chmod 600 "$HOME/.esdoc/credentials"
}

# Initialise ops directories.
_install_ops()
{
    local OPS_DIR="$HOME/esdoc-errata-ws/ops"

    if [[ ! -d "$OPS_DIR" ]]; then
        mkdir -p "$OPS_DIR/config"
        mkdir -p "$OPS_DIR/daemon"
        mkdir -p "$OPS_DIR/logs"
    fi

    if [[ ! -f "$OPS_DIR/config/ws.conf" ]]; then
        cat "$INSTALLER_HOME/templates/ws-app.conf" >> "$OPS_DIR/config/ws.conf"
    fi

    if [[ ! -f "$OPS_DIR/config/supervisord.conf" ]]; then
        cp "$INSTALLER_HOME/templates/ws-supervisord.conf" "$OPS_DIR/config/supervisord.conf"
    fi
}

# Invoke entry point.
main