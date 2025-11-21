#!/bin/bash

# --- Configuration ---
ROUTER_IPS=("10.115.90.58" "10.115.90.59")
SSH_USER="admin"
INTERFACES=(
    "Ethernet1/5" "Ethernet1/6" "Ethernet1/7" "Ethernet1/8"
    "Ethernet1/13" "Ethernet1/14" "Ethernet1/15" "Ethernet1/16"
)
# The refresh interval is now set to 1 second.
SLEEP_INTERVAL=1
LOG_FILE="router_rate_monitor.log"

# --- Create a temporary directory for SSH connections ---
CONTROL_DIR=$(mktemp -d)

# --- SAFETY FUNCTION ---
function cleanup {
    echo -e "\n\nClosing persistent SSH connections..."
    ssh -S "${CONTROL_DIR}/ssh-%r@%h:%p" -O exit "" 2>/dev/null
    rm -rf "${CONTROL_DIR}"
    echo "Monitoring stopped. Log saved to '${LOG_FILE}'."
    exit 0
}
trap cleanup INT TERM

# --- Establish Persistent Connections ---
echo "Establishing persistent SSH connections..."
for router in "${ROUTER_IPS[@]}"; do
    socket_path="${CONTROL_DIR}/ssh-${router}"
    echo "--> Please enter the password for ${SSH_USER}@${router} below:"
    # This assumes your manual 'ssh admin@...' command works.
    ssh -fN -M -S "${socket_path}" "${SSH_USER}@${router}"
    
    if ! ssh -S "${socket_path}" -O check "${router}" 2>/dev/null; then
        echo "Failed to establish a persistent connection to ${router}. Aborting."
        cleanup
    fi
done

# --- Initial Log Message ---
echo "Connections established. Starting monitor..."
echo "Monitoring session started at $(date)" > "${LOG_FILE}"
echo "Output will be displayed and also appended to '${LOG_FILE}'."
sleep 1

# --- Main Monitoring Loop ---
while true; do
    # This command block captures all output for both screen and file
    output_block=$(
        {
            echo
            echo "Last updated: $(date)"
            printf "%-16s %-15s %s\n" "Router" "Interface" "Raw Rate Line"
            echo "-----------------------------------------------------------------------------------------------------"

            for router in "${ROUTER_IPS[@]}"; do
                socket_path="${CONTROL_DIR}/ssh-${router}"
                for interface in "${INTERFACES[@]}"; do
                    
                    # This is the core command. It runs 'show interface' and uses grep
                    # to find ONLY the line containing "pps; output rate"
                    rate_line=$(ssh -S "${socket_path}" "${router}" "show interface ${interface}" | grep "pps; output rate")
                    
                    # Print the router, interface, and the raw line found by grep
                    printf "%-16s %-15s %s\n" "$router" "$interface" "$rate_line"
                done
            done
        }
    )
    
    # Write the output to the log file
    echo "${output_block}" >> "${LOG_FILE}"
    
    # Clear the screen and display the output
    clear
    echo "${output_block}"

    sleep "$SLEEP_INTERVAL"
done
