FROM alpine:edge
MAINTAINER Adrian Hobbs <adrianhobbs@gmail.com>

# Install package using --no-cache to update index and remove unwanted files
RUN 	apk --no-cache add aria2 && \
	# Add a user to run as non root
	adduser -D -g '' aria2

EXPOSE 6800

CMD ["/usr/bin/aria2c","--conf-path=/config/aria2.conf"]

