############################
###       MYSQL VM       ###
############################

# This script is used to backup the active MySQL Database to the Backup Server Copy specified in the variables. It works by taking a dump of the MySQL DB including all databases and sent directly to an NFS Share exposed by the Backup Server. 

# Set Variables. SET ALL VARIABLES BEFORE USE
BACKUP_SERVER=""
MOUNT_DIR=""
SUB_DIR=""
MAILGUN_API_KEY=""
ALERT_EMAIL=""
DUMP_PASSWORD=""

# Check to see if Backup Server is online. If not, exit the script because there is no point in running it.
ping -q -c5 $BACKUP_SERVER > /dev/null
if [ $? -ne 0 ]
then
    curl -s --user "api:key-$MAILGUN_API_KEY" \ # Send using MailGun.
            https://api.mailgun.net/v3/mailgun.felixjen.com/messages \
            -F from='Ikora Alert <ikora@felixjen.com>' \
            -F to="$ALERT_EMAIL" \
            -F subject='Ikora: MySQL Backup Failed' \
            -F text='This is an emergency alert from Ikora. The MySQL scheduled backup has failed because the backup server is unreachable.'
	exit
fi

# Mount the Backup Server using NFS
if [ ! -d "$MOUNT_DIR" ]; then
  mkdir $MOUNT_DIR
fi
mount "$BACKUP_SERVER"/"$SUB_MOUNT" $MOUNT_DIR

# Create the MySQL Database Dump
mysqldump -u root -p$DUMP_PASSWORD --all-databases > $MOUNT_DIR/sql_dump.sql
mysqld --help --verbose > $MOUNT_DIR/conf.txt

# Unmount the NFS Share
umount $MOUNT_DIR