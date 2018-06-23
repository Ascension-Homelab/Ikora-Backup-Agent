############################
###      MYSQL SCRIPT    ###
############################

# This script is used to backup the active MySQL Database to the Backup Server Copy specified in the variables. It works by taking a dump of the MySQL DB including all databases and sent directly to the backup server through an SSH connection after compression.

# Set Variables. SET ALL VARIABLES BEFORE USE
BACKUP_SERVER="" # IP address of the backup server 
BACKUP_SERVER_USER="" # Username for the backup server login
BACKUP_SERVER_PATH="" # Path at the destination, including the final folder name (/path/to/dir/server)
SSH_PASSWORD="" # SSH Password because ssh keys do not work for this
MAILGUN_API_KEY="" # API Key for Mailgun -> api:key-<THIS PART>
MAILGUN_DOMAIN="" # The domain name for emails (i.e. example.com)
ALERT_EMAIL="" # Email Address to receive backup alerts
DUMP_PASSWORD="" # Password to encrypt the MySQL dump with
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

# Create the MySQL Database Dump
mysqldump -u root -p$DUMP_PASSWORD --all-databases | sshpass -p "$SSH_PASSWORD" ssh $BACKUP_SERVER_USER@$BACKUP_SERVER "cat > $BACKUP_SERVER_PATH/mysqlserver.sql"