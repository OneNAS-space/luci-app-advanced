### 新增功能
- 增加了 Terminal system information 作为安装本软件包的附加奖励， 可以自行开启或关闭
开启后效果如下：
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
### 几个小改进
- 更名主菜单为 `Advanced Function`
- 将原本独立菜单项 `File manager`/`File Assistant` 统一合并到主菜单项中，作为 `s.tab` 存在
