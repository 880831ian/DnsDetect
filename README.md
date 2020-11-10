# DnsDetect
DNS偵測

利用Shell 腳本撰寫，可用於掃描該網段是否有IP address 開啟53/UDP Port且開啟對外訪問dns。

利用nmap先檢查該網段是否開啟53/UDP Port，再利用dig來查詢是否有開放對外訪問dns。

## nmap

```shell
nmap -sU -Pn -p 53 $1.* | grep -B3 '53/udp open  domain'
```
## dig 

```shell
dig +short +time=1 $domain @ip address
```
## 用法

```
用法: sh $0 {ip address,help} {domain} {output file}
ip address 請輸入網段即可 Ex :(163.17.10)
help 輸入後可查詢規則
domain 預設值為tw.yahoo.com，輸入後可自行設定domain
outfile 預設值為 b.txt，輸入後可自行設定outfile
```
