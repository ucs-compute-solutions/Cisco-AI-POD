#!/bin/bash

# --- Configuration ---
# List of IP addresses for the AI POD Backend Fabric
HOSTS=(
    "10.115.90.60" # Spine1
    "10.115.90.61" # Spine2
    "10.115.90.58" # Leaf1
    "10.115.90.59" # Leaf2
)

# Commands to be executed on each device
COMMANDS_TO_RUN="
terminal length 0
show version
show run
show interface
show interface transceiver
exit
"

# --- Script Logic ---

# Prompt for credentials
read -p "Enter SSH username: " USERNAME
read -s -p "Enter SSH password: " PASSWORD
echo # for a new line after password entry

# Create a directory for logs, named with the current date
LOG_DIR="configs_backend_$(date +%Y-%m-%d)"
mkdir -p "$LOG_DIR"
echo "Log files will be saved in the '$LOG_DIR' directory."

# Loop through each host
for HOST in "${HOSTS[@]}"; do
    echo "--------------------------------------------------"
    echo "Connecting to $HOST..."

    # Define the output file name
    OUTPUT_FILE="$LOG_DIR/${HOST}.txt"

    # Use sshpass to connect and execute commands
    # The -o options prevent prompts for new SSH host keys
    sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$USERNAME"@"$HOST" <<< "$COMMANDS_TO_RUN" > "$OUTPUT_FILE" 2>&1

    # Check if the connection was successful
    if [ $? -eq 0 ]; then
        echo "Successfully collected logs from $HOST"
        echo "Output saved to: $OUTPUT_FILE"
    else
        echo "Failed to connect or execute commands on $HOST. Check $OUTPUT_FILE for errors."
    fi
done

echo "--------------------------------------------------"
echo "Script finished."
