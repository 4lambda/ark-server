# ARK Server

This repository builds a Docker image for hosting an [ARK](https://store.steampowered.com/app/346110/ARK_Survival_Evolved/) game server.
The image uses the unofficial [Ark Server Tools](https://github.com/FezVrasta/ark-server-tools) to
administrate game instances.

The Docker image is based on [CentOS](https://www.centos.org/) Linux.

By default this image will host a single instance, `main`, but it can be configured to serve multiple
by either:

1. Adding _more_ instance configurations to your container
2. Spawning _more_ containers

The first option will make for a heavier container while the second option may require more management, 
again this all depends on how you orchestrate your containers.

### Recommended Requirements

Insufficient resources will lead to undesirable results:

- Lag
- Crashes
- Unresponsiveness

4Lambda recommends providing (exclusively for your ARK containers) _at least_:

> CPU: 4 or more cores \
RAM: 6 or more gigabytes \
DISK: 30 or more gigabytes

### Usage


##### Starting/Running

The container will download the [ARK](https://store.steampowered.com/app/346110/ARK_Survival_Evolved/) if not
already present. By default (through `/root/crontab`) the container will save and backup every hour
and check for updates every day at 10:30 [UTC](https://www.timeanddate.com/time/zone/timezone/utc).

##### Configuration/Customization

The following sections describe how to modify the instance(s) for your needs.

###### Cron Jobs

To change the default behavior of when backups and updates occur, or if you have _more_ behavior to
add, you can override the default crontab by providing a new cron file at `/ark/crontab`. You can
make a new file or copy the `/root/crontab`.

The `/ark/crontab` file is loaded on container (re)start, if not present then `/root/crontab` is
used. 

Note: If you modify cron using the shell command `crontab -e` your changes **will not persist** between
container starts. The cron for `root` is overwritten at startup. This can be useful if you want to make
temporary changes, however.

###### Global Variables

These variables alter the server environment, they are global and will affect _all_ game instances
in the container.

```bash
TZ='America/Chicago' # Timezone for crontab (see tzselect for help)
```

###### Main Instance Variables

These variables affect the main/default instance. You can leverage these in other instances as well,
peak at the main instance config in `/etc/arkmanager/instances/main.cfg` for reference.


```bash
SESSIONNAME='Ark Docker'      # Name showing in server listings 
SERVERMAP='TheIsland'         # Map of your ark server
SERVERPASSWORD=''             # Password of your ark server (empty/none for no password)
ADMINPASSWORD='adminpassword' # Password for administrating the server for eligible players 
SERVERPORT=27015              # TCP/UDP query port for Steam's server browser
STEAMPORT=7778                # TCP/UDP game client port
RCONPORT=32330                # TCP port for RCON
NPLAYERS=48                   # Max number of players in the server
```

###### Administrators

No user may administrate the server in-game unless they:

1. Know the `ADMINPASSWORD`
2. Their SteamID is present in `/ark/server/ShooterGame/Saved/AllowedCheaterSteamIDs.txt`

You can obtain the SteamID of anyone currently playing by running:

```bash
#> arkmanager rconcmd ListPlayers
```

###### Storage/Volumes

The container will save and work out of `/ark` which you may mount a volume at if you want your data
to persist. If you do not mount a volume your **data will not persist**.

It is recommended to check disk space on your mounted block device periodically as it will fill up 
with the automated backups if not the game world data itself.
