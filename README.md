# coreos-pxe-swarm
Docker image for setting up an CoreOS PXE server 

> This repository is a proof of concept only - don't use in production!
>

## Abstract

see coreos-pxe

### Monitoring

Monitoring the cluster health

```
etcdctl cluster-health
etcdctl member list
```

remove a failed node

```
etcdctl member remove <id>
```
