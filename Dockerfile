FROM            ubuntu:14.04
MAINTAINER      4Lambda Developers <d@4lambda.io>

ENV             SESSIONNAME="Ark Docker" \
                SERVERMAP="TheIsland" \
                SERVERPASSWORD="" \
                ADMINPASSWORD="adminpassword" \
                NBPLAYERS=70 \
                UPDATEONSTART=1 \
                BACKUPONSTART=1 \
                GIT_TAG="v1.6.40" \
                SERVERPORT=27015 \
                STEAMPORT=7778 \
                BACKUPONSTOP=0 \
                WARNONSTOP=0 \
                UID=1000 \
                GID=1000

# Install system packages.
RUN             apt-get -q update \
                && apt-get --no-install-recommends -y install \
                curl \
                lib32gcc1 \
                lsof \
                git \
                ca-certificates \
                vim

# Disable password for sudo.
RUN             sed -i.bkp -e \
	            's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers \
	            /etc/sudoers

# Setup our steam user.
RUN             adduser \
	            --disabled-login \
	            --shell /bin/bash \
	            --gecos "" \
	            steam
RUN             usermod -a -G sudo steam

# Setup our custom configs and crontab mechanism.
ADD             home/steam /home/steam
RUN             touch /root/.bash_profile \
                && chmod 777 /home/steam/run.sh \
                && chmod 777 /home/steam/user.sh \
                && mkdir /ark \
                && ln -s /usr/local/bin/arkmanager /usr/bin/arkmanager

# Install ARK Server Tools.
RUN             git clone https://github.com/FezVrasta/ark-server-tools.git --branch ${GIT_TAG} \
                /home/steam/ark-server-tools \
                && chmod +x /home/steam/ark-server-tools/tools/install.sh
WORKDIR         /home/steam/ark-server-tools/tools
RUN             ./install.sh steam

# Setup /etc files.
ADD             etc/arkmanager/ /etc/arkmanager/
RUN             chown steam -R /ark && chmod 755 -R /ark

# Download steamcmd.
RUN             mkdir /home/steam/steamcmd \
	            && cd /home/steam/steamcmd \
	            && curl http://media.steampowered.com/installer/steamcmd_linux.tar.gz | tar -vxz

EXPOSE          ${STEAMPORT} 32330 ${SERVERPORT} ${STEAMPORT}/udp ${SERVERPORT}/udp
VOLUME          /ark
WORKDIR         /ark
ENTRYPOINT      ["/home/steam/user.sh"]
