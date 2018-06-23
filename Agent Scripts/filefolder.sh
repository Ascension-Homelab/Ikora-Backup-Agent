############################
###      FILE/FOLDER     ###
############################

# This script takes a list of files and folders to be copied to the backup server. This is a generic script and it is up to the user to configure the list of files and folders as appropriate to the use case. This script takes advantage of rsync's delta copy to save on bandwidth and time.

# Set Variables. SET ALL VARIABLES BEFORE USE
BACKUP_SERVER="" # IP address of the backup server
BACKUP_SERVER_USER="" # Username for the backup server login
BACKUP_SERVER_PATH="" # Path at the destination, including the final folder name (/path/to/dir/server)
SSH_PASSWORD="" 
MAILGUN_API_KEY="" # API Key for Mailgun -> api:key-<THIS PART>
MAILGUN_DOMAIN=""
ALERT_EMAIL="" # Email Address to receive backup alerts
FILE_LIST="" # Absolute path to the filelist. See README for filelist format
SERVER_NAME="" # Canonical name for the server to be used in emails


# Check to see if Backup Server is online. If not, exit the script because there is no point in running it.
ping -q -c5 $BACKUP_SERVER > /dev/null
if [ $? -ne 0 ]
then
    curl -s --user "api:key-$MAILGUN_API_KEY" \ # Send using MailGun.
            https://api.mailgun.net/v3/mailgun."$MAILGUN_DOMAIN"/messages \
            -F from="Ikora Alert <ikora@$MAILGUN_DOMAIN>" \
            -F to="$ALERT_EMAIL" \
            -F subject="Ikora: $SERVER_NAME Backup Failed" \
            -F text="This is an emergency alert from Ikora. The $SERVER_NAME scheduled backup has failed because the backup server is unreachable."
	exit
fi

# Import a list of folder locations and associated excludes and puts them into an associative array
# Sourced from https://stackoverflow.com/questions/33605617/how-to-parse-a-text-file-using-shell
declare -A FileList
while IFS== read var val ;do
    [[ "$var" =~ ^[A-Za-z0-9_/]*$ ]] && FileList[$var]=$val # Note that paths with spaces will not work properly. Probably. Haven't tested
done < $FILE_LIST

# Iterate over file locations and excludes and echos for testing

for KEY in "${!FileList[@]}"
do
  rsync -azv -e ssh --delete --exclude-from ${FileList[$KEY]} "$KEY" "$BACKUP_SERVER_USER"@"$BACKUP_SERVER":"$BACKUP_SERVER_PATH"
done
