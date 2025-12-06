### New functions
- `Terminal system information` has been added as an additional reward for installing this software package, which can be turned on or off by yourself.
The effect enabled is as follows：
```
  _______                     ________        __
 |       |.-----.-----.-----.|  |  |  |.----.|  |_
 |   -   ||  _  |  -__|     ||  |  |  ||   _||   _|
 |_______||   __|_____|__|__||________||__|  |____|
          |__| W I R E L E S S   F R E E D O M
 -----------------------------------------------------
 OpenWrt 24.10.4, r28959-29397011cc
 -----------------------------------------------------
 System information as of Sat Dec 06 21:32:35 2025

 System load:     0.00 0.01 0.00 2/154 28535
 CPU usage:       0% usr   2% sys   0% nic  97% idle   0% io   0% irq   0% sirq
 Disk usage:      73% of 109.5M
 Memory usage:    33%
 Processes:       118

 WAN Interfaces List (Original): wan wan6
   IPv4 for wan: 172.22.22.1
   IPv4 for wan:vip: 172.22.2.2
   IPv6 for noprefixroute: 2100:::::1
   IPv6 for noprefixroute: 2100:::::3
   IPv6 for kernel_ll: fe80::6cf5:ccff:fee9:1

 LAN Interfaces List (Original): lan
   IPv4 for br-lan: 192.100.9.1
   IPv4 for br-lan:vip: 192.100.9.2
   IPv6 for noprefixroute: 2100:::::4
   IPv6 for kernel_ll: fe80::203:7fff:feba:1

 WIFI Interfaces List (Original): 

root@MX5300:~#
```
### A few small improvements
- Rename the main menu to `Advanced Function`
- Merge the original independent menu item `File manager`/`File Assistant` into the main menu item and exist as `s.tab`
