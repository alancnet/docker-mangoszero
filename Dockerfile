FROM ryanckoch/docker-ubuntu-14.04

ENV DEBIAN_FRONTEND noninteractive

VOLUME ["/opt/mangos/etc", "/opt/mangos/data", "/opt/mangos/logs"]

RUN apt-get update && \
    apt-get install -y git cmake build-essential libssl-dev\
    libbz2-dev supervisor libace-dev libmysql++-dev liblua5.2-dev lua5.2 && \
    rm -rf /var/lib/apt/lists/*

ADD docker-supervisord.conf /etc/supervisor/conf.d/mangos.conf

RUN mkdir -p /opt/mangos && \
    cd /tmp && \
    git clone https://bitbucket.org/mangoszero/server.git && \
    mv server /opt/mangos/src && \
    git clone https://bitbucket.org/mangoszero/scripts.git && \
    mv scripts /opt/mangos/src && \
    mkdir /opt/mangos/build

RUN cd /opt/mangos/build && \
    cmake -DCMAKE_INSTALL_PREFIX=/opt/mangos -DCMAKE_BUILD_TYPE=Release -DBUILD_TOOLS=OFF ../src && \
    make && \
    make install

EXPOSE 8085 3724

CMD ["/usr/bin/supervisord"]