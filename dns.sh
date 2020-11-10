#!/bin/bash
##############################setting#####################################

green="\e[32m";white="\e[0m";red="\e[31m";blue="\e[34m";yellow="\e[33m"
nowtime=`date "+%F %T"`
starttime=`date +'%Y-%m-%d %H:%M:%S'`
##############################show&check###################################

echo "$1" | egrep '^([0-9]{1,3}\.){2}[0-9]{1,3}$' 1>/dev/null
if [ $? -eq 0 ];then
isip='0'
fi
if [ -z "$2" ];then
domain='tw.yahoo.com'
else
domain="${2}"
fi
if [ -z "$3" ];then
outfile='b.txt'
else
outfile="${3}"
fi
if [ "$1" == "help"  ];then
echo "---------------------------------------------" 
	echo -e "用法: sh $0 {ip address,help} {domain} {output file}"
	echo -e "* ip address 請輸入網段即可 Ex :(163.17.10)"
	echo -e "* help 輸入後可查詢規則"
	echo -e "* domain 預設值為tw.yahoo.com，輸入後可自行設定domain"
	echo -e "* outfile 預設值為 b.txt，輸入後可自行設定outfile"
echo "---------------------------------------------" 
	exit
elif [ -z "$1" ];then 
	echo -e "${red}請輸入IP位址 Ex :( 163.17.10 )或是輸入help來查詢規則${white}"
	exit 
elif [ "${isip}" == "0" ];then
	echo -e "${blue}IP address :${white}${green}$1${white}" | tee -a $outfile
	echo -e "${blue}domain :${white}${green}${domain}${white}" | tee -a $outfile
	echo -e "${blue}outfile :${white}${green}${outfile}${white}" | tee -a $outfile
else
	echo -e "${red}輸入不是IP位址或是help，請重新輸入!${white}"
	exit
fi
echo -e "${blue}Time :${white}${green} $nowtime${white}" | tee -a $outfile
echo -e "${blue}掃描是否開啟 53 port.....${white}"
nmap -sU -Pn -p 53 $1.* | grep -B3 '53/udp open  domain' | grep -o '[0-9\.]\{7,\}' > a.txt
if [ -s "a.txt" ];then
	echo -e "${blue}以下為有開啟 53 port ip address${white}"
echo "---------------------------------------------" 
		while read line;
		do
		echo $line
		done < a.txt
		while read line;
		do
		work=`dig +short +time=1 $domain @${line} 1>/dev/null`
		if [ -z $work ];then
		echo "1" 1>/dev/null
		else
		echo $line >> $outfile
		fi
		done < a.txt
else
	echo -e "${red}沒有開啟 53 port${white}" | tee -a $outfile
fi
echo "---------------------------------------------" | tee -a $outfile
	echo -e "${blue}將檔案輸出至 ${outfile}${white}"
#############################execution time###############################

endtime=`date +'%Y-%m-%d %H:%M:%S'`
start_seconds=$(date --date="$starttime" +%s);
end_seconds=$(date --date="$endtime" +%s);
echo "執行時間：" $((end_seconds-start_seconds))"s";
