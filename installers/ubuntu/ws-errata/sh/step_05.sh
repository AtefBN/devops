# Imports.
source /opt/esgf/devops/installers/ubuntu/shared/sh/constants.sh
source /opt/esgf/devops/installers/ubuntu/shared/sh/init_python.sh
source /opt/esgf/devops/installers/ubuntu/shared/sh/utils.sh

# Main entry point.
main()
{
    log "BEGIN step 5:"

    log "... step 5.1: initialising python venv"
    init_venv "/opt/esdoc-errata-ws" $INSTALLER_PYTHON_2

    log "END step 5"
}

# Invoke entry point.
main
