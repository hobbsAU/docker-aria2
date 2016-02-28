FROM debian:latest
MAINTAINER Adrian Hobbs <adrianhobbs@gmail.com>
ENV DEBIAN_FRONTEND noninteractive
ENV GIT_BRANCH master

# Update packages in base image, avoid caching issues by combining statements, install build software and deps
RUN	apt-get update && apt-get install -y build-essential git pkg-config libssl-dev bzip2 wget zlib1g-dev libswscale-dev python gettext nettle-dev libgmp-dev libssh2-1-dev libgnutls28-dev libc-ares-dev libxml2-dev libsqlite3-dev autoconf libtool libcppunit-dev && \
	rm -rf /var/lib/apt/lists/* && \
	#Install aria2 from git, cleaning up and removing all build footprint	
	git clone https://github.com/tatsuhiro-t/aria2.git /opt/aria2 && \
	cd /opt/aria2 && \
	git checkout $GIT_BRANCH && \
	autoreconf -i && ./configure && \
	make && make install && \
	cd /opt && rm -rf /opt/aria2 && \
	#Clean up removing all build packages and dev libraries, remove unused dependencies and temp files	
	apt-get purge -yqq build-essential git pkg-config libssl-dev bzip2 wget zlib1g-dev libswscale-dev python gettext nettle-dev libgmp-dev libssh2-1-dev libgnutls28-dev libc-ares-dev libxml2-dev libsqlite3-dev autoconf libtool libcppunit-dev && \
	#Install shared libraries only 
	echo "APT::Install-Recommends \"0\";" >> /etc/apt/apt.conf.d/01norecommend && \
	echo "APT::Install-Suggests \"0\";" >> /etc/apt/apt.conf.d/01norecommend && \
	apt-get update && apt-get install -y libxml2 libsqlite3-0 libssh2-1 libc-ares2 && \
	apt-get autoremove --purge -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add a user to run as non root
RUN 	adduser --disabled-password --gecos '' aria2

USER flexget
ENV HOME /home/flexget
EXPOSE 6800

CMD ["/usr/local/bin/aria2c","--conf-path=/config/aria2.conf"]

