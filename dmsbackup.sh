#!/bin/bash
DIRECTORY="/home/minix/docspellbackup/"
FILE_NAME_SUFFIX="_docspell.sqlc"
FILE_NAME="`date +"%Y%m%d"`$FILE_NAME_SUFFIX"
FILE="$DIRECTORY$FILE_NAME"
REMOTE_MOUNT_POINT="/mnt/backup_ecoDMS"

echo "`date +"%Y-%m-%d %H:%M:%S"` Backup file: $FILE"
echo "`date +"%Y-%m-%d %H:%M:%S"` Mount point: $REMOTE_MOUNT_POINT "
echo ""
echo -n "`date +"%Y-%m-%d %H:%M:%S"` Start backup... "
# Run the docker command. See https://docspell.org/docs/install/docker/#backups
# We decide not to stop docspell. According to the documentation, this is optional.
# We have to remove the -it options
docker exec postgres_db pg_dump -d dbname -U dbuser -Fc -f /opt/backup/$FILE_NAME
if [ $? -eq 0 ]; then
	echo "OK"
else
	echo "FAILED"
	exit
fi

# Check if backup file was created
echo -n "`date +"%Y-%m-%d %H:%M:%S"` Check if backup file was created... "
if test -f "$FILE"; then
	echo "OK"
else
	echo "FAILED"
	exit
fi

# Check if we have the remote directory mounted
echo -n "`date +"%Y-%m-%d %H:%M:%S"` Check if we have the remote directory mounted... "
if [[ $(findmnt -M "$REMOTE_MOUNT_POINT") ]]; then
	echo "OK"
else
	echo "FAILED"
	exit
fi

# Copy the backup file to the remote directory
echo -n "`date +"%Y-%m-%d %H:%M:%S"` Copy the backup file to the remote directory... "
cp $FILE $REMOTE_MOUNT_POINT
if [ $? -eq 0 ]; then
	echo "OK"
else
	echo "FAILED"
	exit
fi

# Check if both files are the same
echo -n "`date +"%Y-%m-%d %H:%M:%S"` Check if both files are the same... "
if cmp -s "$FILE" "$REMOTE_MOUNT_POINT/$FILE_NAME"; then
	echo "OK"
else
	echo "FAILED"
	exit
fi

# Remove the file on this machine
echo -n "`date +"%Y-%m-%d %H:%M:%S"` Remove the backup file on this machine... "
rm $FILE
if [ $? -eq 0 ]; then
	echo "OK"
else
	echo "FAILED" 
fi
