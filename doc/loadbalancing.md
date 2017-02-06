# Loadbalancing HA

Der Router wird so konfiguriert, dass er für das große Netz jeden 
Host als Gateway benutzt.


```
sysctl -w net.ipv4.ip_forward=0 ### NICHT NOTWENDING! ###
```


Weiterleiten der gerouteten dienste:



```
iptables -t nat -A PREROUTING -d 10.17.0.0/24 -j DNAT --to-destination 10.16.0.105
```

