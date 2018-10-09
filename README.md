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
