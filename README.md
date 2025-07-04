### File Integrity Monitoring Tool 

This is a Bash-based File Integrity Monitoring (FIM) tool designed to monitor the /etc directory for unauthorized changes. It helps in detecting any added, deleted, or modified files.


### **Key Features**

Monitors critical system directory /etc

Detects file additions, deletions, and modifications

Uses sha256sum for hashing files

Logs results with timestamps in a separate logs/ folder

Includes a --reset option to create a new baseline


### **Folder Structure**

 file_integrity.sh         # Main script
 baseline.hashes           # Stored baseline hashes
 logs/
     alerts_<timestamp>.log  # Scan result logs

### **Make the script executable**

chmod +x file_integrity.sh

### **Create a baseline (required before scanning)**

sudo ./file_integrity.sh --reset

### **Scan for changes**

sudo ./file_integrity.sh

### **View alert logs**

cat logs/alerts_<timestamp>.log

***Notes***

You must run the script with sudo to access all files in /etc.

Do not edit baseline.hashes manually.

Logs are stored in the logs/ folder.

The script currently monitors only /etc. To monitor other directories, edit the MONITOR_DIR variable inside the script.



