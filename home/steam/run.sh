#!/bin/bash
set -eu
trap "arkmanager stop" INT TERM
echo "###########################################################################"
echo "# Ark Server - " `date`
echo "# UID $(id -u) - GID $(id -g)"
echo "###########################################################################"

[ -p /tmp/FIFO ] && rm /tmp/FIFO
mkfifo /tmp/FIFO

# Since /ark is typically an already used volume, verify each file before overwriting.
[ ! -f /ark/arkmanager.cfg ] && cp /home/steam/arkmanager.cfg /ark/arkmanager.cfg
[ ! -f /ark/crontab ] && cp /home/steam/crontab /ark/crontab
[ ! -d /ark/backup ] && mkdir /ark/backup
[ ! -d /ark/staging ] && mkdir /ark/staging
[ ! -L /ark/log ] && ln -s /var/log/arktools log
[ ! -L /ark/Game.ini ] && ln -s server/ShooterGame/Saved/Config/LinuxServer/Game.ini Game.ini
[ ! -L /ark/GameUserSettings.ini ] && ln -s server/ShooterGame/Saved/Config/LinuxServer/GameUserSettings.ini GameUserSettings.ini

crontab /ark/crontab
if [ ! -d /ark/server  ] || [ ! -f /ark/server/version.txt ];then
	echo "No game files found. Installing..."
	arkmanager install
fi
arkmanager start && echo "Running..."

read < /tmp/FIFO &
wait
