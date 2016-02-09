#!/opt/bin/bash

########## CONFIG ##########
#Websites to backup space delimited (the names have to match the names of the folders in your source folder
WEBSITES="website1.com iscConfigUsername.com"

#Remote server host@domain
REMOTE_LOGIN="user@domain.com"

#Source folder on the remote machine
REMOTE_DIR="/var/www/"

#main backup folder
BACKUP_DIR="/volume1/backups/"

#Subfolder where you gonna store the site files example: dirs or files. you can have another for the database
SUB_DIR="dirs/"

#Log folder. We assume that /var/log exists you your local machine. If not create it manually
LOG_DIR="/var/log/backups/"

#Log names
LOG_NAME_DAILY="rdiff-daily.log"
LOG_NAME_WEEKLY="rdiff-weekly.log"
LOG_NAME_MONTHLY="rdiff-monthly.log"
LOG_NAME_YEARLY="rdiff-yearly.log"

############# Some helper functions ##################
create-update-dir() {
	DWMY=$1
	WEBSITE=$2
			if [ ! -d "$BACKUP_DIR" ]; then
				mkdir "$BACKUP_DIR"
			fi
			if [ ! -d "$BACKUP_DIR$DWMY" ]; then
				mkdir "$BACKUP_DIR$DWMY"
			fi
			if [ ! -d "$BACKUP_DIR$DWMY/$WEBSITE" ]; then
				mkdir "$BACKUP_DIR$DWMY/$WEBSITE"
			fi
			if [ ! -d "$BACKUP_DIR$DWMY/$WEBSITE/$SUB_DIR" ]; then
				mkdir "$BACKUP_DIR$DWMY/$WEBSITE/$SUB_DIR"
			fi
			
}

########## Backup Logic ##########

START_TIME=`date +%s` 
DATE=`date +%Y-%m-%d:%H:%M:%S`

#Check if the monthly folder exists and if not create it
if [ ! -d "$LOG_DIR" ]; then
	mkdir $LOG_DIR
fi

#Switch
if [ "$1" = "daily" ]; then
	#Log file
	LOG_FILE="$LOG_DIR$LOG_NAME_DAILY"

	#Add backup delimiter
	echo "########### $DATE daily backup ################" >> $LOG_FILE
		
	for WEBSITE in $WEBSITES
	do
		create-update-dir daily $WEBSITE
		OUTPUT_BACKUP="$(rdiff-backup $REMOTE_LOGIN::$REMOTE_DIR$WEBSITE/web "$BACKUP_DIR$DWMY/$WEBSITE/$SUB_DIR" 2>&1)"
		OUTPUT_DELETE="$(rdiff-backup --remove-older-than 7D "$BACKUP_DIR$DWMY/$WEBSITE/$SUB_DIR" 2>&1)"

		if [ $? -eq 0 ]; then
			echo "$WEBSITE Done" >> $LOG_FILE
		else
			echo "~~~~~~~~~ Error in $WEBSITE ~~~~~~~~~~~~~~~~~~~" >> $LOG_FILE
			echo "${OUTPUT_BACKUP}" >> $LOG_FILE
			echo "${OUTPUT_DELETE}" >> $LOG_FILE
		fi
	done
elif [ "$1" = "weekly" ]; then
	#Log file
	LOG_FILE="$LOG_DIR$LOG_NAME_WEEKLY"

	#Add backup delimiter
	echo "########### $DATE weekly backup ################" >> $LOG_FILE
		
	for WEBSITE in $WEBSITES
	do
		create-update-dir weekly $WEBSITE
		OUTPUT_BACKUP="$(rdiff-backup $REMOTE_LOGIN::$REMOTE_DIR$WEBSITE/web "$BACKUP_DIR$DWMY/$WEBSITE/$SUB_DIR" 2>&1)"
		OUTPUT_DELETE="$(rdiff-backup --remove-older-than 4W "$BACKUP_DIR$DWMY/$WEBSITE/$SUB_DIR" 2>&1)"

		if [ $? -eq 0 ]; then
			echo "$WEBSITE Done" >> $LOG_FILE
		else
			echo "~~~~~~~~~ Error in $WEBSITE ~~~~~~~~~~~~~~~~~~~" >> $LOG_FILE
			echo "${OUTPUT_BACKUP}" >> $LOG_FILE
			echo "${OUTPUT_DELETE}" >> $LOG_FILE
		fi
	done
elif [ "$1" = "monthly" ]; then
	#Log file
	LOG_FILE="$LOG_DIR$LOG_NAME_MONTHLY"

	#Add backup delimiter
	echo "########### $DATE monthly backup ################" >> $LOG_FILE
		
	for WEBSITE in $WEBSITES
	do
		create-update-dir monthly $WEBSITE
		OUTPUT_BACKUP="$(rdiff-backup $REMOTE_LOGIN::$REMOTE_DIR$WEBSITE/web "$BACKUP_DIR$DWMY/$WEBSITE/$SUB_DIR" 2>&1)"
		OUTPUT_DELETE="$(rdiff-backup --remove-older-than 55W "$BACKUP_DIR$DWMY/$WEBSITE/$SUB_DIR" 2>&1)"

		if [ $? -eq 0 ]; then
			echo "$WEBSITE Done" >> $LOG_FILE
		else
			echo "~~~~~~~~~ Error in $WEBSITE ~~~~~~~~~~~~~~~~~~~" >> $LOG_FILE
			echo "${OUTPUT_BACKUP}" >> $LOG_FILE
			echo "${OUTPUT_DELETE}" >> $LOG_FILE
		fi
	done
elif [ "$1" = "yearly" ]; then
	#Log file
	LOG_FILE="$LOG_DIR$LOG_NAME_YEARLY"

	#Add backup delimiter
	echo "########### $DATE yearly backup ################" >> $LOG_FILE
		
	for WEBSITE in $WEBSITES
	do
		create-update-dir yearly $WEBSITE
		OUTPUT_BACKUP="$(rdiff-backup $REMOTE_LOGIN::$REMOTE_DIR$WEBSITE/web "$BACKUP_DIR$DWMY/$WEBSITE/$SUB_DIR" 2>&1)"
		
		if [ $? -eq 0 ]; then
			echo "$WEBSITE Done" >> $LOG_FILE
		else
			echo "~~~~~~~~~ Error in $WEBSITE ~~~~~~~~~~~~~~~~~~~" >> $LOG_FILE
			echo "${OUTPUT_BACKUP}" >> $LOG_FILE
			echo "${OUTPUT_DELETE}" >> $LOG_FILE
		fi
	done
else
	echo "Please use some of the following parameters: daily, weekly, monthly, yearly"
	exit 1
fi

END_TIME=`date +%s`

echo $((END_TIME-START_TIME)) >> $LOG_FILE


