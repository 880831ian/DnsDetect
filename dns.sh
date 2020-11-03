#!/bin/bash
##############################setting#####################################

green="\e[32m";white="\e[0m";red="\e[31m";blue="\e[34m";yellow="\e[33m"
nowtime=`date "+%F %T"`
starttime=`date +'%Y-%m-%d %H:%M:%S'`
##############################show&check###################################

echo -e "${blue}Time :${white}${green} $nowtime${white}" >> b.txt
echo "$1" | egrep '^([0-9]{1,3}\.){2}[0-9]{1,3}$' 1>/dev/null
if [ $? -eq 0 ];then
isip='0'
fi
if [ -z "$2" ];then
domain='tw.yahoo.com'
else
domain="${2}"
fi
if [ "$1" == "help"  ];then
	echo -e "Usage: sh $0 {ip address,help}"
	exit
elif [ -z "$1" ];then 
	echo -e "${red}Please input IP address Ex :( 163.17.10 )or input help to view rules.${white}"
	exit 
elif [ "${isip}" == "0" ];then
	echo -e "${blue}IP address :${white}${green}$1${white}" | tee -a b.txt
	echo -e "${blue}domain :${white}${green}${domain}${white}" | tee -a b.txt
else
	echo -e "${red}The input is not IP address or help${white}"
	exit
fi
echo -e "${blue}scan open 53 port.....${white}"
nmap -sU -Pn -p 53 $1.* | grep -B3 '53/udp open  domain' | grep -o '[0-9\.]\{7,\}' > a.txt
if [ -s "a.txt" ];then
	echo -e "${blue}The following is open 53 port${white}"
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
		echo $line >> b.txt 
		fi
		done < a.txt
else
	echo -e "${red}53 port is not opened${white}" | tee -a b.txt
fi
echo "---------------------------------------------" | tee -a b.txt
	echo -e "${blue}Output to b.txt${white}"
#############################execution time###############################

endtime=`date +'%Y-%m-%d %H:%M:%S'`
start_seconds=$(date --date="$starttime" +%s);
end_seconds=$(date --date="$endtime" +%s);
echo "Execution time：" $((end_seconds-start_seconds))"s";
