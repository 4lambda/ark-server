# ARK: Survival Evolved - Docker

Docker build for managing an ARK: Survival Evolved server.

This image uses [Ark Server Tools](https://github.com/FezVrasta/ark-server-tools) to manage an ark server.

--- 

## Variables

```bash
SESSIONNAME     # (default : "Ark Docker") Name of your ark server 
SERVERMAP       # (default : "TheIsland") Map of your ark server
SERVERPASSWORD  # (default : "") Password of your ark server
ADMINPASSWORD   # (default : "adminpassword") Admin password of your ark server 
SERVERPORT      # (default : 27015) Ark server port
STEAMPORT       # (default : 7778) Steam server port 
RCONPORT        # (default : 32330) RCON port
NPLAYERS        # (default : 48) Max number of players in the server
TZ              # (default : 'America/Chicago') Timezone for crontab (see tzselect for help)
```

--- 

## Volumes

The working directory is on the volume `/ark`.

--- 

## Expose

The 3 port variables will be exposed, `STEAMPORT`, `SERVERPORT`, and `RCONPORT`.

---

## Known issues

---

## Changelog
+ 1.0 : 
  - Initial image : works with Ark Server tools 1.3
  - Add auto-update & auto-backup  
+ 1.1 :  
  - Works with Ark Server Tools 1.4 [See changelog here](https://github.com/FezVrasta/ark-server-tools/releases/tag/v1.4)
  - Handle mods && auto update mods
+ 1.2 :
  - Remove variable AUTOBACKUP & AUTOUPDATE 
  - Remove variable WARNMINUTE (can now be find in arkmanager.cfg)
  - Add crontab support
  - You can now config crontab with the file /your/ark/path/crontab
  - Add template directory with default config files.
  - Add documentation on TZ variable.
+ 1.3-dev :
  - Add BACKUPONSTOP to backup the server when you stop the server (thanks to [fkoester](https://github.com/fkoester))
  - Add WARNONSTOP to add warning message when you stop the server (default: 60 min)
  - Works with Ark Server Tools v1.5
    - Compressing backups so they take up less space
    - Downloading updates to a staging directory before applying
    - Added support for automatically updating on restart
    - Show a spinner when updating
  - Add UID & GID to set the uid & gid of the user used in the container (and permissions on the volume /ark)
+ 1.4-dev :
  - Use Git 1.6
+ 2.0 :
  - Fork TuRz4m repository
  - Add VIM
  - Rebuild with newer arkserver tools
  - Keep backups on `/ark` volume instead of `/home/backup`
  - Shrink and rehash the `run.sh` script
  - Switched to CentOS
  - Updated `Dockerfile` commands for CentOS
  - Container user switched from `root` to `steam` for security
+ 2.1 :
  - Updated to Ark Server Tools master
  - Updated config files for updated Ark Server Tools
  - Set default crontab
  - Removed several variables
  - Removed `user.sh` script in favor of `Dockerfile` configuration
  - Use new `steamcmd`
  - Include `vim` for debugging/maintenance
  - Strip comments out of config files (slim down)
  - Fix FIFO read/write pipe permissions
  - Fix `PATH` variable for cron jobs
  - Sorted ark-server-tools variables based on ark-server-tools wiki
+ 2.1.1 :
  - Force crontab into roots cronjobs
+ 2.1.2 :
  - Fix permissions for steam user and group on `/ark/backup` and `/ark/staging`
+ 2.1.3 :
  - Fixed `PATH` after failed fix in 2.1 for cron environment
+ 2.1.4 :
  - Use 4Lambda CentOS base image
  - Update README
  - Add `RCONPORT` variable
  - Remove quotes where they're unnecessary
