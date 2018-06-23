# Ikora-Backup-Agent
Agent for the Ikora Backup System developed for the Ascension Homelab

## Tasks

Tasks are defined by a general set of scripts which take configuration options as either variables or as a secondary configuration file. 

### MySQL

#### TO AMEND
The MySQL task will take a dump of all MySQL Databases and store the file into a local destination specified. The file will then be copied over to the destination server irregardless of whether the database has changed. The local copy is then destroyed.

### File/Folder

#### About

The File/Folder task is designed to make a carbon copy of a list of folders and all files inside to a remote backup destination using rsync. The task first checks the availability of the backup server (through ping). Assuming the server is available, it parses a secondary configuration file (described below) into an associative array of folders and excludes. The task then iterates over the entire associative arrow, noting the *key* and *value* from the associative array. The *key* is passed to `rsync` as the folder source and the *value* is passed as the location of an exclude file. `rsync` uses SSH to transfer the files to the remote server.

#### Configuration Steps

1. Create a filelist.txt file
2. Generate and copy SSH keys to the remote server

#### FileList

As noted earlier, the File/Folder task takes a filelist as a secondary configuration file. The filelist is in the format of:

```
/path/to/source/dir=/path/to/exclude/file
/path/to/source/dir2=/path/to/exclude/file2
```

Note that each line represents an individual `rsync` task. The first parameter will be used as the source for `rsync` so `rsync` will attempt to transfer that directory. The second parameter is the exclude file, a plaintext file that `rsync` will reference. An exclude file is required for every source path, even if one is not needed, in which a blank file can be used. The exclude file should consist of paths or regex for folders or files to exclude from the backup process.

## Backing Up

Backup is done to Google Drive with unlimited storage using rclone in this current setup. 

### Configuration

1. Download rclone 
2. Add Google Drive as a remote, possibly using new OAuth credentials
3. Add `crypt` as a remote since backups are encrypted
4. `rclone -L copy /path/to/backups <name of crypt remote>:`

## Restoring

1. Download rclone
2. Add Google Drive as a remote, possibly using new OAuth credentials
3. Add `crypt` as a remote since backups are encrypted, using same passphrase and blank salt
4. Sync rclone copy to local from the `crypt` remote

Consult (this link)[https://gist.github.com/briantkatch/95b159ed5ba7e1d5d85d74c6e4b04dea] for a more detailed documentation on backing up and restoring using rclone (6/22/18). 