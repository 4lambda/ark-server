# ARK: Survival Evolved - Docker

Docker build for managing an ARK: Survival Evolved server.

This image uses [Ark Server Tools](https://github.com/FezVrasta/ark-server-tools) to manage an ark server.

--- 

### Variables

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


### Volumes

The working directory is on the volume `/ark`.


### Expose

The 3 port variables will be exposed, `STEAMPORT`, `SERVERPORT`, and `RCONPORT`.


### Cron

You can edit the `crontab` as you see fit. At the time of writing, it will make hourly backups
and update at 10:30 AM CST. **Note** that the `crontab` is loaded each time the container starts,
if you make changes to `/root/crontab` within the container, they will not persist when the
container is rebooted. See `/root/run.sh` for the details.
