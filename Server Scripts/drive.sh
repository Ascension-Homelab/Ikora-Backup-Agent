#######################
### BACKUP TO DRIVE ###
#######################

# This script checks if another rclone process is running. If it is, then exit. Otherwise, start one. 

# Set Variables
BACKUP_LOCATION=""
CRYPT_REMOTE_NAME=""

if pgrep -x "rclone" > /dev/null
then
    exit
else
    rclone -L copy "$BACKUP_LOCATION" "$CRYPT_REMOTE_NAME":
fi