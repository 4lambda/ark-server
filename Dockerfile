FROM            registry.gitlab.com/rustydb/docker/centos
MAINTAINER      4Lambda Developers <d@4lambda.io>

# Install system packages.
RUN             yum -y -q install \
                    perl-Compress-Zlib \
                    lsof \
                    glibc.i686 \
                    libstdc++.x86_64 \
                    libstdc++.i686 \
                    bzip2 \
                    git \
                    vim \
                    cronie \
                && yum -q clean all

# Setup our steam user.
RUN             adduser \
                --shell /bin/bash \
                --uid 1000 \
                steam

# Install steamcmd.
RUN             mkdir /home/steam/steamcmd \
                && cd /home/steam/steamcmd \
                && curl -sqL 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar zxvf - \
                && chown -R steam:steam /home/steam/steamcmd

# Install ARK Server Tools.
RUN            curl -sL http://git.io/vtf5N | bash -s steam

# Setup /etc files.
ADD             etc/ /etc/

# Prepare ARK volume.
ADD             root/ /root/
RUN             mkdir /ark \
                && chmod 777 -R /ark
WORKDIR         /ark
VOLUME          /ark

# Runtime setup.
ENV             SESSIONNAME='Ark Docker' \
                SERVERMAP='TheIsland' \
                SERVERPASSWORD='' \
                ADMINPASSWORD='adminpassword' \
                NPLAYERS=48 \
                SERVERPORT=27015 \
                STEAMPORT=7778 \
                RCONPORT=32330 \
                TZ='America/Chicago'
EXPOSE          ${STEAMPORT} ${RCONPORT} ${SERVERPORT} ${STEAMPORT}/udp ${SERVERPORT}/udp
ENTRYPOINT      ["/bin/bash"]
CMD             ["/root/run.sh"]
