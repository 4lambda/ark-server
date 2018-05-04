#!/bin/bash
set -eu
trap "arkmanager stop --warn" INT TERM
echo "###########################################################################"
echo "# Ark Server - " `date`
echo "# UID $(id -u) - GID $(id -g)"
echo "###########################################################################"

[ -p /tmp/FIFO ] && rm /tmp/FIFO
mkfifo /tmp/FIFO

export TERM=linux

# Add a template directory to store the last version of config file.
[ ! -d /ark/template ] && mkdir /ark/template
cp /home/steam/arkmanager.cfg /ark/template/arkmanager.cfg
cp /home/steam/crontab /ark/template/crontab

[ ! -f /ark/arkmanager.cfg ] && cp /home/steam/arkmanager.cfg /ark/arkmanager.cfg
[ ! -L /ark/log ] && ln -s /var/log/arktools log
[ ! -d /ark/backup ] && mkdir /ark/backup
[ ! -d /ark/staging ] && mkdir /ark/staging
[ ! -L /ark/Game.ini ] && ln -s server/ShooterGame/Saved/Config/LinuxServer/Game.ini Game.ini
[ ! -L /ark/GameUserSettings.ini ] && ln -s server/ShooterGame/Saved/Config/LinuxServer/GameUserSettings.ini GameUserSettings.ini
[ ! -f /ark/crontab ] && cp /ark/template/crontab /ark/crontab

if [ ! -d /ark/server  ] || [ ! -f /ark/server/arkversion ];then 
	echo "No game files found. Installing..."
	arkmanager install --verbose
fi

# If there is uncommented line in the file
CRONNUMBER=`grep -v "^#" /ark/crontab | wc -l`
if [ $CRONNUMBER -gt 0 ]; then
	echo "Loading crontab..."
	# We load the crontab file if it exist.
	crontab /ark/crontab
else
	echo "No crontab set."
fi

arkmanager start

echo "Running..."
read < /tmp/FIFO &
wait
