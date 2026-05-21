# Imports.
source /opt/esgf/devops/installers/ubuntu/shared/sh/constants.sh
source /opt/esgf/devops/installers/ubuntu/shared/sh/init_python.sh
source /opt/esgf/devops/installers/ubuntu/shared/sh/utils.sh

# Main entry point.
main()
{
    log "BEGIN step 3:"

    log "... step 3.1: initialising python"
    init_python $INSTALLER_PYTHON_2

    log "END step 3"
}

# Invoke entry point.
main
