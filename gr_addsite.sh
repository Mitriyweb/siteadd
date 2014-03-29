#!/bin/bash/
set -e 
# absolute way to directory scripts
ABSOLUTE_FILENAME=`readlink -e "$0"`
DIRECTORY=`dirname "$ABSOLUTE_FILENAME"`
cd $DIRECTORY
. config.sh


SITENAME=$(gdialog --title "ADDSITE" --inputbox "Input site name:" 120 60 2>&1)


if	[ -z $SITENAME ]; then
	      gdialog --title "ADDSITE" --msgbox "ERROR SITE NEED NAME" 10 60 0
	      exit 0
else
		if  [ -f $APACHE/$SITENAME ]; then
		gdialog --title "ADDSITE" --msgbox "ERROR SITE NAME EXISTS" 10 60 0
		exit 0
		else
			cd $BASEDIR
			mkdir $SITENAME  $SITENAME/www
			chown -R $USER:$USER  $SITENAME
			
			cd $DIRECTORY
			cp site $SITENAME
			sed -i -e 's%/site_dir/%'$BASEDIR% $SITENAME
			sed -i -e 's%site_name%'$SITENAME% $SITENAME
			cp $SITENAME $APACHE
			rm $SITENAME
			a2ensite $SITENAME
			/etc/init.d/apache2 restart
			echo "127.0.0.1  $SITENAME" | tee  >> $HOSTS
			
			if	[ -z $SQL_PSW ]; then
				
				mysql  -u $SQL_USR  -h $SQL_HOST -e "create database IF NOT EXISTS \`$SITENAME\` CHARACTER SET utf8 COLLATE utf8_general_ci;"
				
			else
				mysql  -u $SQL_USR -h $SQL_HOST -p$SQL_PSW  -e "create database IF NOT EXISTS \`$SITENAME\` CHARACTER SET utf8 COLLATE utf8_general_ci;"
			fi
		gdialog --title "ADDSITE" --msgbox "SITE ADDS FINISH" 10 60 0
	fi
fi