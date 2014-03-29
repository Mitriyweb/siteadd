#!/bin/bash/
set -e 

# absolute way to directory scripts
ABSOLUTE_FILENAME=`readlink -e "$0"`
DIRECTORY=`dirname "$ABSOLUTE_FILENAME"`
cd $DIRECTORY
. config.sh
#CONFIG

SITENAME=$(gdialog --title "RMSITE" --inputbox "Input site name:" 120 60 2>&1)

# absolute way to directory scripts
ABSOLUTE_FILENAME=`readlink -e "$0"`
DIRECTORY=`dirname "$ABSOLUTE_FILENAME"`

if	[ -z $SITENAME ]; then
	      gdialog --title "RMSITE" --msgbox "ERROR SITE NEED NAME" 10 60 0
	      exit 0
else
		if  [ -f $APACHE/$SITENAME ]; then
			cd $BASEDIR
			rm -r $SITENAME
			cd $APACHE
			rm $SITENAME 
			a2dissite $SITENAME
			/etc/init.d/apache2 restart
			
			cd $DIRECTORY
			grep -v $SITENAME $HOSTS  > hosts
			cp hosts $HOSTSDIR
			rm hosts
		
			if	[ -z $SQL_PSW ]; then
				mysqladmin -f -u $SQL_USR -h $SQL_HOST drop  $SITENAME
			else
				mysqladmin -f -u $SQL_USR -h $SQL_HOST -p$SQL_PSW  drop  $SITENAME
			fi
		
		else
			gdialog --title "RMSITE" --msgbox "ERROR NAME DOES NOT EXISTS" 10 60 0
			exit 0
		fi
	gdialog --title "RMSITE" --msgbox "SITE RM FINISH" 10 60 0
fi
