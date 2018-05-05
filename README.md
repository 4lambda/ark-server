# ARK: Survival Evolved - Docker

Docker build for managing an ARK: Survival Evolved server.

This image uses [Ark Server Tools](https://github.com/FezVrasta/ark-server-tools) to manage an ark server.

--- 

## Variables
+ __SESSIONNAME__
Name of your ark server (default : "Ark Docker")
+ __SERVERMAP__
Map of your ark server (default : "TheIsland")
+ __SERVERPASSWORD__
Password of your ark server (default : "")
+ __ADMINPASSWORD__
Admin password of your ark server (default : "adminpassword")
+ __SERVERPORT__
Ark server port (can't rebind with docker, it doesn't work) (default : 27015)
+ __STEAMPORT__
Steam server port (can't rebind with docker, it doesn't work) (default : 7778) 
+ __NPLAYERS__
Max number of players in the server (default : 48)
+ __TZ__
Time Zone : Set the container timezone (for crontab). (You can get your timezone posix format with the command `tzselect`. For example, France is "Europe/Paris").


--- 

## Volumes
+ __/ark__ : Working directory :
    + /ark/server : Server files and data.
    + /ark/log : logs
    + /ark/backup : backups
    + /ark/arkmanager.cfg : config file for Ark Server Tools
    + /ark/crontab : crontab config file
    + /ark/Game.ini : ark game.ini config file
    + /ark/GameUserSetting.ini : ark gameusersetting.ini config file
    + /ark/template : Default config files
    + /ark/template/arkmanager.cfg : default config file for Ark Server Tools
    + /ark/template/crontab : default config file for crontab
    + /ark/staging : default directory if you use the --downloadonly option when updating.

--- 

## Expose
+ Port : __STEAMPORT__ : Steam port (default: 7778)
+ Port : __SERVERPORT__ : server port (default: 27015)
+ Port : __32330__ : rcon port

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
+ 1.3 :
  - Add BACKUPONSTOP to backup the server when you stop the server (thanks to [fkoester](https://github.com/fkoester))
  - Add WARNONSTOP to add warning message when you stop the server (default: 60 min)
  - Works with Ark Server Tools v1.5
    - Compressing backups so they take up less space
    - Downloading updates to a staging directory before applying
    - Added support for automatically updating on restart
    - Show a spinner when updating
  - Add UID & GID to set the uid & gid of the user used in the container (and permissions on the volume /ark)
+ 2.0 :
  - Switched to CentOS
  - Updated to Ark Server Tools master
  - Updated config files for updated Ark Server Tools
  - Set default crontab
  - Removed several variables
  - Removed `user.sh` script in favor of `Dockerfile` configuration
  - Use new `steamcmd`
  - Include `vim` for debugging/maintenance
  - Strip comments out of config files (slim down)
