FROM busybox
MAINTAINER hadrien.mary@gmail.com

# Add sysadmin user
run echo 'sysadmin:x:1000:1000::/data:/bin/sh' >> /etc/passwd
run echo 'sysadmin:x:1000:' >> /etc/group

run mkdir /data
run chown sysadmin.sysadmin /data
run chmod 777 /data
run touch /data/init_volume

WORKDIR /data
VOLUME /data
