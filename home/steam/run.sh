#!/bin/bash
trap "arkmanager stop" INT TERM
echo "###########################################################################"
echo "# Ark Server - $(date)"
echo "###########################################################################"
[ -p /tmp/FIFO ] && rm /tmp/FIFO
mkfifo /tmp/FIFO

# Setup volume files.
[ ! -f /ark/arkmanager.cfg ] && cp /home/steam/arkmanager.cfg /ark/arkmanager.cfg
[ ! -f /ark/crontab ] && cp /home/steam/crontab /ark/crontab
[ ! -d /ark/backup ] && mkdir /ark/backup
[ ! -d /ark/staging ] && mkdir /ark/staging
[ ! -L /ark/log ] && ln -s /var/log/arktools log
[ ! -L /ark/Game.ini ] && ln -s server/ShooterGame/Saved/Config/LinuxServer/Game.ini Game.ini
[ ! -L /ark/GameUserSettings.ini ] && ln -s server/ShooterGame/Saved/Config/LinuxServer/GameUserSettings.ini GameUserSettings.ini

# Add our crontab and start the daemon.
if [[ $(crontab -u steam -l | diff crontab -) ]]; then
    echo "steam's crontab differs from /ark/crontab and will be overwritten!"
fi
crontab -u steam /ark/crontab
crond

# Install if this is a new volume.
if [ ! -d /ark/server  ] || [ ! -f /ark/server/version.txt ]; then
	echo "No game files found. Installing..."
	arkmanager install
fi
arkmanager start && echo "Running..."

read < /tmp/FIFO &
wait
