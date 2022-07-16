FROM            ghcr.io/4lambda/centos:8 as base

RUN             yum install -y \
                    bzip2-1.0.6-26.el8 \
                    cronie-1.5.2-7.el8 \
                    git-2.31.1-2.el8 \
                    glibc-2.28-206.el8.i686 \
                    libstdc++-8.5.0-13.el8.i686 \
                    lsof-4.93.2-1.el8 \
                    perl-IO-Compress-2.081-1.el8 \
                    vim-enhanced-2:8.0.1763-19.el8.4 \
                && yum -q clean all

FROM base as app-base
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

# Setup our steam user.
RUN             adduser \
                --shell /bin/bash \
                --uid 1000 \
                steam && \
                mkdir -v /ark /configs && \
                chmod 777 /ark /configs && \
                chmod 777 /etc/environment && \
                curl -L http://git.io/vtf5N >/root/install.sh && \
                bash /root/install.sh steam && \
                crond
USER            steam
WORKDIR         /home/steam/steamcmd
RUN             curl -sqL 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar zxvf -

# Setup /etc files and ARK volume
COPY            etc /etc/
COPY            crontab run.sh /home/steam/

VOLUME          /ark
VOLUME          /configs

EXPOSE          ${STEAMPORT} ${RCONPORT} ${SERVERPORT} ${STEAMPORT}/udp ${SERVERPORT}/udp
WORKDIR         /ark
CMD             ["/home/steam/run.sh"]
