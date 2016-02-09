
rdiff-autorotator

Description

The script creates 4 folders in the desired backup folder - daily, weekly, monthly and yearly. It makes incremental backups in 
each folder when it is run with one of the following parameters - daily, weekly, monthly and yearly. The incremental backups are 
deleated as follows:
Daily - after 7 Days
Weekly - after 4 weeks
Monthly - after 12 months
Yearly - never
Basicly you will be able to restore your data from each of the last 7 days, last 4 weeks (1 per week), last 12 months (1 per month) 
or from any past year (1 per year)

INSTALLATION
Copy the file to /usr/local/bin
change the permission - chmod 755
CONFIGURATION
This script works with the ISPCONFIG folder structure. 
/var |
     | www|
          | website1.com|
                        |web
  if this is your case just add the website names as they apear in /var/www to WEBSITES variable seprated by spaces
  Add your remote login data username@domain. 
  IMPORTANT this script asumes that you know how to make passwordless login to a remote server. If dont just google it.
  Set the following cronjobs:
  
30       2       *       *       *       root    /usr/local/bin/rdiff-autorotator.v.1.0.sh daily
30       3       *       *       2       root    /usr/local/bin/rdiff-autorotator.v.1.0.sh weekly
30       4       8       *       *       root    /usr/local/bin/rdiff-autorotator.v.1.0.sh monthly
30       5       8       2       *       root    /usr/local/bin/rdiff-autorotator.v.1.0.sh yearly

The above cronjobs assumes that:
1. the name of the script is: rdiff-autorotator.v.1.0.sh
2. the location of it is /usr/local/bin
3. daily backups are done at 2:30 am
4. weekly backups are done at 3:30 am every Tuesday
5. monthly backups are done  at 4:40 am every 8th of the month
6. yearly backups are done at 5:30 am every February 8th

  
          
