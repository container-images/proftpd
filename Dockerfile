FROM fedora:25

ADD files/proftpd-module.repo /etc/yum.repos.d/proftpd-module.repo
ADD files/gen-core-module.repo /etc/yum.repos.d/gen-core-module.repo


RUN dnf -y --disablerepo=* --enablerepo=proftpd-module --enablerepo=gen-core-module install proftpd

# FTP user
RUN useradd --shell /bin/sh proftpd

# Configuration
ADD files/proftpd.conf /etc/proftpd.conf
RUN chown -R proftpd:proftpd /etc/proftpd.conf

# Service irectories
RUN mkdir -p /var/proftpd-container && \
    mkdir -p /etc/proftpd-container

# User account files
#ADD files/custom.passwd /etc/proftpd-container/custom.passwd
#ADD files/custom.group /etc/proftpd-container/custom.group

# Service irectories
RUN chown -R proftpd:proftpd /var/proftpd-container && \
    chown -R proftpd:proftpd /etc/proftpd-container && \
    chmod 755 /etc/proftpd-container

# FTP volume
VOLUME ['/ftp', '/etc/proftpd-container-workaround']

# And let's go!
USER proftpd
CMD mkdir /etc/proftpd-container/perm-workaround && \
    cp /etc/proftpd-container-workaround/custom.* /etc/proftpd-container/perm-workaround/ && \
    chmod -R 750 /etc/proftpd-container/perm-workaround && \
    proftpd --nodaemon
