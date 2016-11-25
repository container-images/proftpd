# FTP Server Container: proftpd

An example **FTP server container** running as a **non-root user** based on **Fedora 25**. This container is being developed - test it, play with it, but please **don't use it in production**.

For convenience in the **early development stage**, the container has a **hardcoded user**:

```
username: adam
password: 1234
UID: 1001
GID: 1001
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
