# FTP Server Container: proftpd

![three-layer-arch](/doc/three-layer-arch.png)

This repository defines the **Layer 3** in the three-layer module container architecture.

Other layer repositories:
[**Layer 1**](https://github.com/asamalik/fake-gen-core-module-image) | 
[**Layer 2**](https://github.com/asamalik/fake-proftpd-module-image) | 
[**Layer 3**](https://github.com/container-images/proftpd)

## Description

An example **FTP server container** running as a **non-root user** based on **Fedora 25**. This container is being developed - test it, play with it, but please **don't use it in production**.

For convenience in the **early development stage**, the container has a **hardcoded user**:

```
username: adam
password: 1234
UID: 1001
GID: 1001
```

Default ports are as follows:

```
command port:        10021 (changed from the default 21 to allow running as a non-root user)
passive mode ports:  10100 - 10110
```

## Running in Docker

```
$ docker run -p 21:10021 -p 10100-10110:10100-10110 -v <DIR>:/ftp asamalik/proftpd-container
```

Substitute `<DIR>` with a mount point containing a sub-directory for each user. For example:

```
$ mkdir -p ftp/adam
$ chown 1001:1001 ftp/adam
$ docker run -p 21:10021 -p 10100-10110:10100-10110 -v $(pwd)/ftp:/ftp asamalik/proftpd-container
```

## Running in OpenShift

To run this container in OpenShift, you need to change the `RunAsUser` option in the `restricted` Security Context Constraint (SCC) from `MustRunAsRange` to `RunAsAny`. This is because `proftpd` is changing its UID in runtime - this needs to be fixed in the future. Do it by running:

```
$ oc login -u system:admin
$ oc project default
$ oc edit scc restricted
```

Find `RunAsUser` and change its value from `MustRunAsRange` to `RunAsAny`.

Then you will be able to run the container using the `openshift-template.yml` template in this repo:

```
oc login -u developer
oc create -f openshift-template.yml
```

The template is not using any persistent storage or configuration, it uses the hardcoded `adam` user.
