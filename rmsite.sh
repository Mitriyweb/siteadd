#!/bin/bash/
set -e 

# absolute way to directory scripts
ABSOLUTE_FILENAME=`readlink -e "$0"`
DIRECTORY=`dirname "$ABSOLUTE_FILENAME"`
cd $DIRECTORY
. config.sh

#CONFIG


# absolute way to directory scripts
ABSOLUTE_FILENAME=`readlink -e "$0"`
DIRECTORY=`dirname "$ABSOLUTE_FILENAME"`

SITENAME=$1

if	[ -z $SITENAME ]; then
	      echo "ERROR SITE NEED NAME"
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
			echo 'ERROR NAME DOES NOT EXISTS'
			exit 0
		fi
fi