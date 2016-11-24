FROM fedora:25

RUN dnf -y install proftpd

# FTP user
RUN useradd --shell /bin/sh proftpd

# Configuration
ADD proftpd.conf /etc/proftpd.conf
RUN chown -R proftpd:proftpd /etc/proftpd.conf

# Service irectories
RUN mkdir -p /var/proftpd-container && \
    mkdir -p /etc/proftpd-container

# User account files
ADD custom.passwd /etc/proftpd-container/custom.passwd
ADD custom.group /etc/proftpd-container/custom.group

# Service irectories
RUN chown -R proftpd:proftpd /var/proftpd-container && \
    chown -R proftpd:proftpd /etc/proftpd-container && \
    chmod 700 /etc/proftpd-container/custom.passwd

# FTP volume
VOLUME /ftp

# And let's go!
USER proftpd
CMD exec proftpd --nodaemon
