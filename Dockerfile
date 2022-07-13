FROM            ghcr.io/4lambda/centos:8 as base

RUN             yum -y -q install \
                    bzip2-1.0.6-26.el8 \
                    cronie-1.5.2-7.el8 \
                    git-2.31.1-2.el8 \
                    glibc-2.28-206.el8 \
                    libstdc++-8.5.0-13.el8 \
                    lsof-4.93.2-1.el8 \
                    perl-IO-Compress-2.081-1.el8 \
                    vim-enhanced-2:8.0.1763-19.el8.4 \
                && yum -q clean all

FROM base as app-base

# Setup our steam user.
RUN             adduser \
                --shell /bin/bash \
                --uid 1000 \
                steam

# Install steamcmd and ARK Server Tools.
WORKDIR         /home/steam/steamcmd
RUN             curl -fsqL 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar zxvf - \
                && chown -R steam:steam /home/steam/steamcmd \
                && curl -fsL http://git.io/vtf5N | bash -s steam

# Setup /etc files and ARK volume
ADD             etc/ /etc/
ADD             root/ /root/

VOLUME          /ark
VOLUME          /configs

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
WORKDIR         /ark
ENTRYPOINT      ["/bin/bash"]
CMD             ["/root/run.sh"]
