# coreos-pxe-swarm
Docker image for setting up an CoreOS PXE server 

> This repository is a proof of concept only - don't use in production!
>

## Abstract

see coreos-pxe

### Booting the pxe initial machine (DHCP Proxy mode with external DHCP Server) 

```
docker run --net=host  -e INTERFACE_BOOTSTRAP=eth2 -v /root/.ssh/id_rsa.pub:/root/rsa_public_key --name corepxe dermatthes/coreos-pxe-swarm
```

After booting the the first machine, shutdown the service. 
 
### Activate internal DHCP Server

```
docker run --net=host -e INTERFACE_BOOTSTRAP=eth2 -e DHCP_RANGE="set:gateway1,192.168.123. -v /root/.ssh/id_rsa.pub:/root/rsa_public_key --name corepxe dermatthes/coreos-pxe-swarm
```


## ALL Options


### Using Config-File

All Environment-Variables can be defined in one single config-file

```
INTERFACE_BOOTSTRAP="xyz"

```

```
docker run --net=host -v /path/to/config:/root/config -v ~/.ssh/id_rsa.pub:/root/rsa_public_key --name corepxe dermatthes/coreos-pxe-swarm
```


### Environment

| Option              | Default           | Description                                           |
|---------------------|-------------------|-------------------------------------------------------|
| INTERFACE_BOOTSTRAP | eth2              | Interface to start the PXE server in bootstrap mode   |
| MODE                | BOOTSTRAP         | (Internal only)                                       |
| INTERFACE           | enp0s5            | Primary network interface to configure on nodes       |
| DHCP_RANGE          | <myip>,proxy      | Pass DHCP options                                     |
| NFS_MOUNT           | <ip>:/path        | NFS Mount to mount in /mnt                            |

### Authorized Keys

Make sure to provide a SSH public key to `/root/rsa_public_key`. Do not 
loose this key. It is the only way to log into the cluster!

```
-v ~/.ssh/id_rsa.pub:/root/rsa_public_key
```
Will do the task for your local user.



### Auto formating harddisks

By default the disks labeld with `COREOS_ROOT` will be formated 
 on reboot. To initialize a new harddisk you'll have to manually
 label this device:

```
sudo mkfs.ext4 -L COREOS_ROOT /dev/sda
```

Login to the first node.


### Starting NFS4 Server auf dem externen Fileserver

```
apt-get install nfs-kernel-server
```

/etc/exports
```
/mnt  10.16.0.0/24(rw,async,no_subtree_check,no_root_squash,fsid=0)
```


```
service nfs-kernel-server restart
```

and start `sudo systemctl restart rpc-mountd`


### Mounten von shares

Per Option `-e NFS_MOUNT="<ip>:/nfs/path"` wird das Verzeichnis 
angegeben, dass bei allen Nodes auf /mnt gemounted wird.

## Ausführen eines Scripts auf der ersten Node (PXE)

Script einfach per -v einbinden:

```
-v /path/to/script:/root/bootstrap_run.sh
```

Hier kann z.B. ein `docker login` erfolgen oder irgendwelche
Secrets hinterlegt werden.


## Ausführen eines Scripts auf allen Nodes nach erfolgtem Startup

Script einfach per -v einbinden:

```
-v /path/to/script:/root/master_run.sh
```