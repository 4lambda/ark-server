#!/bin/bash
trap "arkmanager stop" INT TERM
echo "###########################################################################"
echo "# Ark Server - $(date)"
echo "###########################################################################"
[ -p /tmp/FIFO ] && rm /tmp/FIFO
mkfifo -m 666 /tmp/FIFO

# Setup volume files.
[ ! -d /ark/backup ] && mkdir /ark/backup && chown -R steam:steam /ark/backup
[ ! -d /ark/staging ] && mkdir /ark/staging  && chown -R steam:steam /ark/staging
[ ! -L /ark/log ] && ln -s /var/log/arktools log
[ ! -L /ark/Game.ini ] && ln -s server/ShooterGame/Saved/Config/LinuxServer/Game.ini Game.ini
[ ! -L /ark/GameUserSettings.ini ] && ln -s server/ShooterGame/Saved/Config/LinuxServer/GameUserSettings.ini GameUserSettings.ini

# Load our crontab, setup cron's environment, and start the cron daemon.
crontab /root/crontab
env > /etc/environment
crond

# Install if this is a new volume.
if [ ! -d /ark/server  ] || [ ! -f /ark/server/version.txt ]; then
	echo "No game files found. Installing..."
	arkmanager install
fi

arkmanager start

echo "Running..."
read < /tmp/FIFO &
wait