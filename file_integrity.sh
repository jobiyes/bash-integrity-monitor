#!/bin/bash

# Directory to monitor
MONITOR_DIR="/etc"

# Baseline and temporary hash files
BASELINE_FILE="./baseline.hashes"
TMP_CURRENT="./current.hashes"

# Log directory and log file with timestamp
LOG_DIR="./logs"
TIMESTAMP=$(date '+%Y-%m-%d-%H-%M')
ALERT_LOG="$LOG_DIR/alerts_$TIMESTAMP.log"

# Create the log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Handle --reset flag to generate a new baseline
if [[ "$1" == "--reset" ]]; then
    echo "[INFO] Creating new baseline for $MONITOR_DIR ..."
    sudo find "$MONITOR_DIR" -type f -exec sha256sum {} \; 2>/dev/null | LC_ALL=C sort > "$BASELINE_FILE"
    echo "[INFO] Baseline created at $BASELINE_FILE"
    exit 0
fi

# Exit if no baseline file exists
if [ ! -s "$BASELINE_FILE" ]; then
    echo "[ERROR] No baseline found. Please run: sudo ./file_integrity.sh --reset"
    exit 1
fi

# Generate current hash values for monitored files
sudo find "$MONITOR_DIR" -type f -exec sha256sum {} \; 2>/dev/null | LC_ALL=C sort > "$TMP_CURRENT"

# Start writing the alert log
echo "Scanning for changes in $MONITOR_DIR" > "$ALERT_LOG"
echo "Timestamp: $TIMESTAMP" >> "$ALERT_LOG"
echo "----------------------------------------" >> "$ALERT_LOG"

# Use associative arrays to store hash values
declare -A BASE CURRENT
ADDED=false
MODIFIED=false
DELETED=false

# Read baseline hashes into array
while read -r hash path; do
    BASE["$path"]="$hash"
done < "$BASELINE_FILE"

# Read current hashes into array
while read -r hash path; do
    CURRENT["$path"]="$hash"
done < "$TMP_CURRENT"

# Detect deleted and modified files
for path in "${!BASE[@]}"; do
    if [[ -z "${CURRENT[$path]}" ]]; then
        echo "[DELETED]  $path" >> "$ALERT_LOG"
        DELETED=true
    elif [[ "${BASE[$path]}" != "${CURRENT[$path]}" ]]; then
        echo "[MODIFIED] $path" >> "$ALERT_LOG"
        MODIFIED=true
    fi
done

# Detect newly added files
for path in "${!CURRENT[@]}"; do
    if [[ -z "${BASE[$path]}" ]]; then
        echo "[ADDED]    $path" >> "$ALERT_LOG"
        ADDED=true
    fi
done

# If no changes are found, log that too
if ! $ADDED && ! $MODIFIED && ! $DELETED; then
    echo "No changes detected." >> "$ALERT_LOG"
fi

# Delete the temporary hash file
rm "$TMP_CURRENT"


