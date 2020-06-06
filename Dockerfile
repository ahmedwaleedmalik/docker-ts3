FROM ubuntu:18.04

# Label
LABEL name="Docker-ts3" \
      maintainer="ahmedwaleedmalik@gmail.com" \
      summary="Teamspeak 3 Server in a docker container"

# Arguments
ARG TS3_SERVER_VERSION="3.12.1"
ARG TS3_SERVER_ARCH="linux_amd64"
ARG TS3_SERVER_BINARY_URL="https://files.teamspeak-services.com/releases/server/${TS3_SERVER_VERSION}/teamspeak3-server_${TS3_SERVER_ARCH}-${TS3_SERVER_VERSION}.tar.bz2"
ARG TS3_DIRECTORY="/teampspeak-data"

# Locale
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Set DEBIAN_FRONTEND to noninteractive
ENV DEBIAN_FRONTEND noninteractive

# Set-up teamspeak
RUN apt-get update && \
		apt-get upgrade -y && \
		apt-get install -y wget ca-certificates bzip2 && \
		mkdir -p ${TS3_DIRECTORY} && \
    wget -q -O ${TS3_DIRECTORY}/teamspeak.tar.bz2 ${TS3_SERVER_BINARY_URL} && \
    tar xvf ${TS3_DIRECTORY}/teamspeak.tar.bz2 -C ${TS3_DIRECTORY} --strip-components 1  && \
    rm ${TS3_DIRECTORY}/teamspeak.tar.bz2

# Create user
RUN	groupadd -g 9999 teamspeak && \
		useradd -u 9999 -g 9999 -d ${TS3_DIRECTORY} teamspeak && \
		chown teamspeak:teamspeak -R ${TS3_DIRECTORY}

# Create directory for logs and files
RUN	mkdir -p ${TS3_DIRECTORY}/files && chown teamspeak:teamspeak ${TS3_DIRECTORY}/files && \
		mkdir -p ${TS3_DIRECTORY}/logs && chown teamspeak:teamspeak ${TS3_DIRECTORY}/logs

# Accept TS3 License Agreement
RUN touch ${TS3_DIRECTORY}/.ts3server_license_accepted

# Cleanup
RUN	apt-get -qq autoremove -y --purge && \
		apt-get -qq clean && \
		rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apk/*

# Set user
USER teamspeak

# Expose server port, file port, server query port
EXPOSE 9987/udp 10011/tcp 30033/tcp

WORKDIR "$TS3_DIRECTORY"
VOLUME ["$TS3_DIRECTORY"]

ENTRYPOINT ["/teampspeak-data/ts3server_minimal_runscript.sh"]
CMD ["inifile=/teampspeak-data/ts3server.ini", "logpath=/teampspeak-data/logs","licensepath=/teampspeak-data","query_ip_whitelist=/teampspeak-data/query_ip_whitelist.txt","query_ip_backlist=/teampspeak-data/query_ip_blacklist.txt"]