# DnsDetect
DNS偵測

`利用Shell 腳本撰寫，可用於掃描該網段是否有IP address 開啟53/UDP Port且開啟對外訪問dns。`

`利用nmap先檢查該網段是否開啟53/UDP Port，再利用dig來查詢是否有開放對外訪問dns。`

## nmap

```sh
nmap -sU -Pn -p 53 $1.* | grep -B3 '53/udp open  domain'
```
