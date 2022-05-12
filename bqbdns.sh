#!/usr/bin/env bash
RED_COLOR="\033[0;31m"
NO_COLOR="\033[0m"
GREEN="\033[32m\033[01m"
BLUE="\033[0;36m"
FUCHSIA="\033[0;35m"
echo "export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin:$PATH" >> ~/.bashrc
source ~/.bashrc
if [[ "$EUID" -ne 0 ]]; then
    echo "false"
  else
    echo "true"
  fi
if [[ -f /etc/redhat-release ]]; then
		release="centos"
	elif cat /etc/issue | grep -q -E -i "debian"; then
		release="debian"
	elif cat /etc/issue | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
	elif cat /proc/version | grep -q -E -i "debian"; then
		release="debian"
	elif cat /proc/version | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
    fi
    
     if [[ $release = "ubuntu" || $release = "debian" ]]; then
    PM='apt'
  elif [[ $release = "centos" ]]; then
    PM='yum'
  else
    exit 1
  fi
  # PM='apt'
  if [ $PM = 'apt' ] ; then
    apt-get install -y cron
    service cron start
elif [ $PM = 'yum' ]; then 
    yum install -y vixie-cron
    yum install -y crontabs
    service cron start
fi
cd /root/ && wget -N --no-check-certificate "https://raw.githubusercontent.com/liujang/bqb/main/changedns.sh" && chmod +x changedns.sh
echo -e "
 ${GREEN} 1.hk
 ${GREEN} 2.jp
 ${GREEN} 3.sgp
 ${GREEN} 4.us
 "
  read -p "输入选项:" aNum
 if [ "$aNum" = "1" ];then
 sed -i '10s/area/'hk'/' /root/changedns.sh
 elif [ "$aNum" = "2" ];then
 sed -i '10s/area/'jp'/' /root/changedns.sh
 elif [ "$aNum" = "3" ];then
 sed -i '10s/area/'sgp'/' /root/changedns.sh
 elif [ "$aNum" = "4" ];then
 sed -i '10s/area/'us'/' /root/changedns.sh
 fi
 ./changedns.sh
 echo "已更换dns"
read -p "多少小时重新获取dns:" dnstime
crontab -l > conf
echo "0 */${dnstime} * * * /root/changedns.sh" >> conf
crontab conf
rm -f conf
echo "已设置每${dnstime}小时重新获取dns"