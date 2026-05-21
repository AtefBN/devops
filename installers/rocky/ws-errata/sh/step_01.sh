# Imports.
source /opt/esgf/devops/installers/ubuntu/shared/sh/utils.sh
source /opt/esgf/devops/installers/ubuntu/shared/sh/init_sys.sh

# Main entry point.
main()
{
    log "BEGIN step 1:"

    log "... step 1.1: initialising system"
    init_sys_libs

    log "... step 1.2: initialising services"
    init_sys_services

    log "... step 1.3: initialising permissions"
    init_sys_permissions

    log "END step 1"
}

# Invoke entry point.
main