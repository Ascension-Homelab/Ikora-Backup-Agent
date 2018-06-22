####################
### Google Drive ###
####################

# This script is used to facilitate the transfer of files to Google Drive from the backup copy on the local. First, a check is done to see if a previous backup exists. If there is one, there would be a file called "timestamp.txt" with the name of the previous backup folder.

# Assuming one does, it creates a duplicate on the Google Drive end and renamed to the current date and time. Then, an rsync is done between the two folders to determine what needs to be copied and if there exist any changes. If there are, the rsync will take care of it. The timestamp file is changed to reflect the new folder's name

# If there is no previous backup folder, a new folder with the current date and time is created. The directory is copied over and the timestamp file is created.