# Erste Schritte auf dem Docker server.

Commands, die auf Swarm-Ebene ausgeführt werden sollen, werden per
`docker service` verfügbar gemacht.

Eine Shell aufmachen:

```
docker service create busybox sleep 100
```

Services sehen:

```
docker service ls
```

Sehen wo was läuft

```
docker service ps <serviceid>
```


Ein Overlay-Network erstellen (Swarmweit)

```
docker network create --driver overlay --subnet 10.100.0.0/24 --opt enrypted <name>
```

Service an Netzwerk anschließen

```
docker service create --network <network> <image
```

Lookup:

```
docker service create --replicas 5 --name some-name <image>
```

In einem anderen container kann dieser per DNS gefunden werden.

```
ping some-name
```