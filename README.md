# Ikora-Backup-Agent
Agent for the Ikora Backup System developed for the Ascension Homelab

## Requirements
1. Check to see if there exists a configuration file
2. If there is a file, proceed to stage **Backup**
3. If there is not a file, prompt about creation of the file or quit
4. Create the file and ask for destination Server IP
5. Close the program and tell user to modify the file as necessary
**Backup**
1. Define multiple backup types (MySQL,File/Folder,Shell Output, etc...)
2. Based on the configuration file which defines the backup types, perform the correct action
3. Either store directly into the local, or send immediately to destination server into the specified directory

## Tasks

Tasks are defined 

### MySQL

The MySQL task will take a dump of all MySQL Databases and store the file into a local destination specified. The file will then be copied over to the destination server irregardless of whether the database has changed. The local copy is then destroyed.

### File/Folder

The File/Folder task takes in an array of folders to be backed up. The script perform an immediate rsync of files 