# File Integrity Monitoring Tool 

This is a Bash-based File Integrity Monitoring (FIM) tool designed to monitor the /etc directory for unauthorized changes. It helps in detecting any added, deleted, or modified files.



## Key Features

1.Monitors critical system directory /etc

2.Detects file additions, deletions, and modifications

3.Uses sha256sum for hashing files

4.Logs results with timestamps in a separate logs/ folder

5.Includes a ```--reset``` option to create a new baseline



## Folder Structure
```
./
  ├── file_integrity.sh      # Main script
  ├── baseline.hashes        # Stored baseline hashes
  ├── logs/                  # Directory for log files
  │     └── alerts_.log        # Log file for alerts

```
  

## Make the script executable
```
chmod +x file_integrity.sh
```


## Create a baseline (required before scanning)
```
sudo ./file_integrity.sh --reset
```

Use ```--reset``` to generate a snapshot of all files in /etc.

Do this only once and after that only when you want to update the baseline.hases file



## View alert logs
```
cat logs/alerts_<timestamp>.log
```


***Notes***

You must run the script with sudo to access all files in /etc.

Do not edit ```baseline.hashes``` manually.

Logs are stored in the logs/ folder.

The script currently monitors only /etc. To monitor other directories, edit the MONITOR_DIR variable inside the script.



