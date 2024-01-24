## Linux commands
- Dispaly linux system info
```
uname -a
```
![uname](./uname.png)

- show how long the sytem is running
```
uptime
```
![uptime](./uptime.png)

- show system reboot history
```
last reboot
```
![reboot](./reboot.png)

- who am i loggedin as
```
whoami
```
![whoami](./whoami.png)

- who is online
```
w
```
![online](./w.png)

- show the filepath of the binary
```
which bash
```
![bashpath](./bash.png)

- display free and used memory
```
free -h
```
![free](./free.png)

- show info about disk sda
```
hdparm -i /dev/sda
```
![disksda](./disksda.png)

- perform read test on disk sda
```
hdparm -tT /dev/sda
```
![testdisksda](./testdisksda.png)

- dispaly listening tcp and udp port
```
netstat -nutlp
```
![tcpudp](./tcpudp.png)

- display dns info for domain
```
dig philipoyelegbin.github.io
```
![dns](./dns.png)

- reverse lookuo for IP addresses
```
dig -x 185.199.108.153
```
![rdns](./rdns.png)
