#!/bin/bash
trap "arkmanager stop" INT TERM
echo "###########################################################################"
echo "# Ark Server - $(date)"
echo "# (USER: $UID; GROUP: $GROUPS)"
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
if [[ -e /ark/crontab ]]; then
    echo "Loading volume crontab (/ark/crontab)"
    crontab /ark/crontab
else
    echo "Loading default crontab (/root/crontab)"
    crontab /home/steam/crontab
fi
env > /etc/environment

# Install if this is a new volume.
if [ ! -d /ark/server  ] || [ ! -f /ark/version.txt ]; then
    echo "No game files found. Installing..."
    arkmanager install
    arkmanager --version >/ark/version.txt 2>&1
fi

if [ -d /configs ]; then
    for config in $(find /configs -type f -iregex '.*\.ini'); do
        if diff ${config} /ark/server/ShooterGame/Saved/Config/LinuxServer/$(basename $file); then
            cp -pv ${config} /ark/server/ShooterGame/Saved/Config/LinuxServer/$(basename $file)
        fi
    done
fi

arkmanager start

echo "Running..."
read < /tmp/FIFO &
wait
