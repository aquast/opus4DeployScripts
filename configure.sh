#!/bin/bash

##
# This file is part of the Pre-Deployment Tool for OPUS4
# Script for configuration of OPUS4-Software in front of being installed
#
# @author Andres Quast 
# @email quast@hbz-nrw.de
# @copyright 2015 - 2017 Hochschulbibliothkszentrum des Landes Nordrhein-Westfalen
# @licence  http://www.gnu.org/licenses/gpl.html General Public License
# Version 1.1
# created 2015-04-29
#
# LICENCE
# This is free software; you can redistribute it and/or modify it under the
# terms of the GNU General Public License as published by the Free Software
# Foundation; either version 2 of the Licence, or any later version.
# preMigration Suite is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
# details. You should have received a copy of the GNU General Public License
# along with preMigration Suite; if not, write to the Free Software Foundation, Inc., 51
# Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
##


BASEDIR=`pwd`
echo "*** ***"
echo "*** Configure OPUS4 Instance***"
echo "basic configuration uses Path for automatic config"
echo
echo "$BASEDIR will be used as BASEDIR"
INSTANCENAME=`echo $BASEDIR | sed -e "s!.*/!!g"` 
echo "$INSTANCENAME will be used as INSTANCENAME"
echo

echo "setup for apacheconf/opus4"
sed -e "s!<basedir>!$BASEDIR!; s!<instancename>!$INSTANCENAME!" apacheconf/opus4.template > apacheconf/opus4
echo "setup for install/install.sh"
sed -e "s!<basedir>!$BASEDIR!; s!<instancename>!$INSTANCENAME!; s!--system \"!--system --create-home -d $BASEDIR --shell /bin/bash \"!" install/install.sh.template > install/install.sh
echo "setup for install/uninstall.sh"
sed -e "s!<basedir>!$BASEDIR!; s!<instancename>!$INSTANCENAME!" install/uninstall.sh.template > install/uninstall.sh
echo "setup for install/opus4-solr-jetty.conf.template"
sed -i -e "s!<basedir>!$BASEDIR!; s!<instancename>!$INSTANCENAME!" install/opus4-solr-jetty.conf.template
echo "setup for opus4/public/.htaccess"
sed -e "s!<basedir>!$BASEDIR!; s!<instancename>!$INSTANCENAME!" opus4/public/htaccess.template > opus4/public/.htaccess

echo "chmod for workspace"
find workspace/ -type d -print0 |xargs -r0 chmod 666
find workspace/ -type f -print0 |xargs -r0 chmod 666

# for ubuntu only:
echo "configure apache2 on ubuntu systems"
cd /etc/apache2/sites-available
ln -s /var/local/$INSTANCENAME/apacheconf/opus4 $INSTANCENAME.conf
a2ensite $INSTANCENAME.conf
service apache2 reload