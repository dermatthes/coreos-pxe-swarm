# coreos-pxe-swarm
Docker image for setting up an CoreOS PXE server 

> This repository is a proof of concept only - don't use in production!
>

## Abstract

see coreos-pxe

### Booting the pxe initial machine

```
docker run --net=host -e MODE=BOOTSTRAP -e INTERFACE=eth2 -v /root/.ssh/id_rsa.pub:/app/rsa_public_key --name corepxe dermatthes/coreos-pxe-swarm
```

After booting the the first machine, shutdown the service. 
 

Login to the first node.