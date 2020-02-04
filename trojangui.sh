#!/bin/bash
clear

if [[ $(id -u) != 0 ]]; then
		echo Please run this script as root.
		exit 1
fi

if [[ $(uname -m 2> /dev/null) != x86_64 ]]; then
		echo Please run this script on x86_64 machine.
		exit 1
fi

if [[ -f /etc/init.d/aegis ]] || [[ -f /etc/systemd/system/aliyun.service ]]; then
systemctl stop aegis || true
systemctl disable aegis || true
rm -rf /etc/init.d/aegis || true
systemctl stop CmsGoAgent.service || true
systemctl disable CmsGoAgent.service || true
rm -rf /etc/systemd/system/CmsGoAgent.service || true
systemctl stop aliyun || true
systemctl disable aliyun || true
systemctl stop cloud-config || true
systemctl disable cloud-config || true
systemctl stop cloud-final || true
systemctl disable cloud-final || true
systemctl stop cloud-init-local.service || true
systemctl disable cloud-init-local.service || true
systemctl stop cloud-init || true
systemctl disable cloud-init || true
systemctl stop exim4 || true
systemctl disable exim4 || true
systemctl stop apparmor || true
systemctl disable apparmor || true
rm -rf /etc/systemd/system/aliyun.service || true
rm -rf /lib/systemd/system/cloud-config.service || true
rm -rf /lib/systemd/system/cloud-config.target || true
rm -rf /lib/systemd/system/cloud-final.service || true
rm -rf /lib/systemd/system/cloud-init-local.service || true
rm -rf /lib/systemd/system/cloud-init.service || true
systemctl daemon-reload || true
	if [[ $(lsb_release -cs) == stretch ]]; then
							cat > '/etc/apt/sources.list' << EOF
#------------------------------------------------------------------------------#
#                   OFFICIAL DEBIAN REPOS                    
#------------------------------------------------------------------------------#

###### Debian Main Repos
deb http://deb.debian.org/debian/ oldstable main contrib non-free
deb-src http://deb.debian.org/debian/ oldstable main contrib non-free

deb http://deb.debian.org/debian/ oldstable-updates main contrib non-free
deb-src http://deb.debian.org/debian/ oldstable-updates main contrib non-free

deb http://deb.debian.org/debian-security oldstable/updates main
deb-src http://deb.debian.org/debian-security oldstable/updates main

deb http://ftp.debian.org/debian stretch-backports main
deb-src http://ftp.debian.org/debian stretch-backports main
EOF
fi
	if [[ $(lsb_release -cs) == bionic ]]; then
							cat > '/etc/apt/sources.list' << EOF
#------------------------------------------------------------------------------#
#                            OFFICIAL UBUNTU REPOS                             #
#------------------------------------------------------------------------------#

###### Ubuntu Main Repos
deb http://us.archive.ubuntu.com/ubuntu/ bionic main restricted universe multiverse 
deb-src http://us.archive.ubuntu.com/ubuntu/ bionic main restricted universe multiverse 

###### Ubuntu Update Repos
deb http://us.archive.ubuntu.com/ubuntu/ bionic-security main restricted universe multiverse 
deb http://us.archive.ubuntu.com/ubuntu/ bionic-updates main restricted universe multiverse 
deb-src http://us.archive.ubuntu.com/ubuntu/ bionic-security main restricted universe multiverse 
deb-src http://us.archive.ubuntu.com/ubuntu/ bionic-updates main restricted universe multiverse 
EOF
echo "nameserver 1.1.1.1" > '/etc/resolv.conf' || true
	fi
fi
#######color code############
ERROR="31m"      # Error message
SUCCESS="32m"    # Success message
WARNING="33m"   # Warning message
INFO="36m"     # Info message
LINK="92m"     # Share Link Message
#############################
cipher_server="ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384"
cipher_client="ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES128-SHA:ECDHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA:AES128-SHA:AES256-SHA:DES-CBC3-SHA"
#############################
colorEcho(){
		COLOR=$1
		echo -e "\033[${COLOR}${@:2}\033[0m"
}
#########Domain resolve verification###################
isresolved(){
		if [ $# = 2 ]
		then
				myip=$2
		else
				myip=`curl -s http://dynamicdns.park-your-domain.com/getip`
		fi
		ips=(`nslookup $1 1.1.1.1 | grep -v 1.1.1.1 | grep Address | cut -d " " -f 2`)
		for ip in "${ips[@]}"
		do
				if [ $ip == $myip ] || [ $ip == $myipv6 ] || [[ $ip == $localip ]]
				then
						return 0
				else
						continue
				fi
		done
		return 1
}
###############User input################
userinput(){
whiptail --clear --ok-button "吾意已決 立即執行" --title "User choose" --checklist --separate-output --nocancel "請按空格來選擇:
若不確定，請保持默認配置並回車" 25 90 17 \
"系统相关" "" on  \
"1" "系统升级(System Upgrade)" on \
"2" "安裝BBR | TCP效能优化(TCP-Turbo)" on \
"3" "安裝BBRPLUS" off \
"代理相关" "" on  \
"4" "安裝Trojan-GFW" on \
"5" "安裝Dnsmasq | DNS缓存与广告屏蔽(dns cache and ad block)" on \
"6" "安裝V2ray | Websocket+tls+Nginx模式(wss mode)" off \
"7" "安裝Shadowsocks | Websocket+tls+Nginx模式(wss mode)" off \
"8" "安裝Tor-Relay | Relay模式(not exit relay)" off \
"下载相关" "" on  \
"9" "安裝Qbittorrent | 强大的BT客户端(Powerful Bittorrent Client)" on \
"10" "安裝Bittorrent-Tracker" on \
"11" "安裝Aria2" on \
"12" "安裝Filebrowser | 文件下载与共享(File download and share)" on \
"状态监控" "" on  \
"13" "安裝Netdata | 服务器状态监控(Server status monitor)" on \
"其他" "" on  \
"14" "仅启用TLS1.3(Enable TLS1.3 only)" off 2>results

while read choice
do
	case $choice in
		1) 
		system_upgrade=1
		;;
		2) 
		install_bbr=1
		;;
		3)
		install_bbrplus=1
		;;
		4)
		install_trojan=1
		;;
		5) 
		dnsmasq_install=1
		;;
		6) 
		install_v2ray=1
		;;
		7) 
		install_ss=1
		;;
		8)
		install_tor=1
		;;
		9)
		install_qbt=1
		;;
		10)
		install_tracker=1
		;;
		11)
		install_aria=1
		;;
		12)
		install_file=1
		;;
		13)
		install_netdata=1
		;;
		14) 
		tls13only=1
		;;
		*)
		;;
	esac
done < results
####################################
if (whiptail --title "api" --yesno --defaultno "使用 (use) api?推荐，可用于申请wildcard证书" 8 78); then
	dns_api=1
	APIOPTION=$(whiptail --clear --ok-button "吾意已決 立即執行" --title "API choose" --menu --separate-output "請按空格來選擇" 18 78 10 \
"1" "Cloudflare Using the global api key " \
"2" "Use Namesilo.com API" \
"3" "Use Aliyun domain API"  3>&1 1>&2 2>&3)

	case $APIOPTION in
		1)
		cf_api=1
		while [[ -z $CF_Key ]]; do
		CF_Key=$(whiptail --passwordbox --nocancel "https://dash.cloudflare.com/profile/api-tokens，快輸入你CF_Key併按回車" 8 78 --title "CF_Key input" 3>&1 1>&2 2>&3)
		done
		while [[ -z $CF_Email ]]; do
		CF_Email=$(whiptail --inputbox --nocancel "https://dash.cloudflare.com/profile，快輸入你CF_Email併按回車" 8 78 --title "CF_Key input" 3>&1 1>&2 2>&3)
		done
		export CF_Key="$CF_Key"
		export CF_Email="$CF_Email"
		;;
		2)
		namesilo_api=1
		while [[ -z $Namesilo_Key ]]; do
		Namesilo_Key=$(whiptail --passwordbox --nocancel "https://www.namesilo.com/account_api.php，快輸入你的Namesilo_Key併按回車" 8 78 --title "Namesilo_Key input" 3>&1 1>&2 2>&3)
		done
		export Namesilo_Key="$Namesilo_Key"
		;;
		3)
		ali_api=1
		while [[ -z $Ali_Key ]]; do
		Ali_Key=$(whiptail --passwordbox --nocancel "https://ak-console.aliyun.com/#/accesskey，快輸入你的Ali_Key併按回車" 8 78 --title "Ali_Key input" 3>&1 1>&2 2>&3)
		done
		while [[ -z $Ali_Secret ]]; do
		Ali_Secret=$(whiptail --passwordbox --nocancel "https://ak-console.aliyun.com/#/accesskey，快輸入你的Ali_Secret併按回車" 8 78 --title "Ali_Secret input" 3>&1 1>&2 2>&3)
		done
		export Ali_Key="$Ali_Key"
		export Ali_Secret="$Ali_Secret"
		;;
		*)
		;;
	esac
	fi
####################################
if [[ $system_upgrade = 1 ]]; then
	if [[ $(lsb_release -cs) == stretch ]]; then
		if (whiptail --title "System Upgrade" --yesno "Upgrade to Debian 10?" 8 78); then
			debian10_install=1
		else
			debian10_install=0
		fi
	fi
	if [[ $(lsb_release -cs) == jessie ]]; then
		if (whiptail --title "System Upgrade" --yesno "Upgrade to Debian 9?" 8 78); then
			debian9_install=1
		else
			debian9_install=0
		fi
	fi
	if [[ $(lsb_release -cs) == xenial ]]; then
		if (whiptail --title "System Upgrade" --yesno "Upgrade to Ubuntu 18.04?" 8 78); then
			ubuntu18_install=1
		else
			ubuntu18_install=0
		fi
	fi
fi
#####################################
while [[ -z $domain ]]; do
domain=$(whiptail --inputbox --nocancel "朽木不可雕也，糞土之牆不可污也，快輸入你的域名並按回車" 8 78 --title "Domain input" 3>&1 1>&2 2>&3)
if [[ $domain == "" ]]; then
	ip=$(curl -s https://api.ipify.org)
	if [[ $dist = centos ]]; then
		yum install -y -q bind-utils
		else
		apt-get install dnsutils -y -qq
	fi
	domain=$(host $ip)
	if [[ -f /etc/trojan/trojan.crt ]] || [[ $dns_api == 1 ]]; then
	:
	else
	if isresolved $domain
	then
	:
	else
	clear
	whiptail --title "Domain verification fail" --msgbox --scrolltext "域名解析验证失败，请自行验证解析是否成功并且请关闭Cloudfalare CDN并检查VPS控制面板防火墙(80 443)是否打开!!!Domain verification fail,Pleae turn off Cloudflare CDN and Open port 80 443 on VPS panel !!!" 8 78
	colorEcho ${ERROR} "域名解析验证失败，请自行验证解析是否成功并且请关闭Cloudfalare CDN并检查VPS控制面板防火墙(80 443)是否打开!!!"
	colorEcho ${ERROR} "Domain verification fail,Pleae turn off Cloudflare CDN and Open port 80 443 on VPS panel !!!"
	exit -1
	clear
	fi  
fi
fi
done
if [[ $install_trojan = 1 ]]; then
	while [[ -z $password1 ]]; do
password1=$(whiptail --passwordbox --nocancel "別動不動就爆粗口，你把你媽揣兜了隨口就說，快輸入你想要的密碼一併按回車" 8 78 --title "password1 input" 3>&1 1>&2 2>&3)
if [[ $password1 == "" ]]; then
	password1=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 20 ; echo '' )
	fi
done
while [[ -z $password2 ]]; do
password2=$(whiptail --passwordbox --nocancel "你別逼我在我和你全家之間加動詞或者是名詞啊，快輸入想要的密碼二並按回車" 8 78 --title "password2 input" 3>&1 1>&2 2>&3)
if [[ $password2 == "" ]]; then
	password2=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 20 ; echo '' )
	fi
done
fi
###################################
	if [[ $install_qbt = 1 ]]; then
		while [[ -z $qbtpath ]]; do
		qbtpath=$(whiptail --inputbox --nocancel "Put your thinking cap on，快输入你的想要的Qbittorrent路径并按回车" 8 78 /qbt/ --title "Qbittorrent path input" 3>&1 1>&2 2>&3)
		done
	fi
#####################################
		if [[ $install_tracker = 1 ]]; then
			while [[ -z $trackerpath ]]; do
			trackerpath=$(whiptail --inputbox --nocancel "Put your thinking cap on，快输入你的想要的Bittorrent-Tracker路径并按回车" 8 78 /announce --title "Bittorrent-Tracker path input" 3>&1 1>&2 2>&3)
			done
			while [[ -z $trackerstatuspath ]]; do
			trackerstatuspath=$(whiptail --inputbox --nocancel "Put your thinking cap on.，快输入你的想要的Bittorrent-Tracker状态路径并按回车" 8 78 /status --title "Bittorrent-Tracker download path input" 3>&1 1>&2 2>&3)
			done
		fi
####################################
		if [[ $install_aria = 1 ]]; then
			while [[ -z $ariapath ]]; do
			ariapath=$(whiptail --inputbox --nocancel "Put your thinking cap on.，快输入你的想要的Aria2 RPC路径并按回车" 8 78 /jsonrpc --title "Aria2 path input" 3>&1 1>&2 2>&3)
			done
			while [[ -z $ariapasswd ]]; do
			ariapasswd=$(whiptail --passwordbox --nocancel "Put your thinking cap on.，快输入你的想要的Aria2 rpc token并按回车" 8 78 --title "Aria2 rpc token input" 3>&1 1>&2 2>&3)
			if [[ $ariapasswd == "" ]]; then
			ariapasswd="123456789"
			fi
			done
		fi
####################################
		if [[ $install_file = 1 ]]; then
			while [[ -z $filepath ]]; do
			filepath=$(whiptail --inputbox --nocancel "Put your thinking cap on，快输入你的想要的Filebrowser路径并按回车" 8 78 /files/ --title "Filebrowser path input" 3>&1 1>&2 2>&3)
			done
		fi
####################################
		if [[ $install_netdata = 1 ]]; then
			while [[ -z $netdatapath ]]; do
			netdatapath=$(whiptail --inputbox --nocancel "Put your thinking cap on，快输入你的想要的Netdata路径并按回车" 8 78 /netdata/ --title "Netdata path input" 3>&1 1>&2 2>&3)
			done
		fi
####################################
		if [[ $install_v2ray = 1 ]]; then
			while [[ -z $path ]]; do
			path=$(whiptail --inputbox --nocancel "Put your thinking cap on，快输入你的想要的V2ray Websocket路径并按回车" 8 78 /secret --title "Websocket path input" 3>&1 1>&2 2>&3)
			done
			while [[ -z $alterid ]]; do
			alterid=$(whiptail --inputbox --nocancel "快输入你的想要的alter id大小(只能是数字)并按回车" 8 78 64 --title "alterid input" 3>&1 1>&2 2>&3)
			done
		fi
####################################
		if [[ $install_tor = 1 ]]; then
			while [[ -z $tor_name ]]; do
			tor_name=$(whiptail --inputbox --nocancel "你別逼我在我和你全家之間加動詞或者是名詞啊，快輸入想要的tor nickname並按回車" 8 78 --title "tor nickname input" 3>&1 1>&2 2>&3)
			if [[ $tor_name == "" ]]; then
			tor_name="myrelay"
		fi
done
		fi
####################################
		if [[ $install_ss = 1 ]]; then
			while [[ -z $sspath ]]; do
			sspath=$(whiptail --inputbox --nocancel "Put your thinking cap on，快输入你的想要的ss-Websocket路径并按回车" 8 78 /ss --title "ss-Websocket path input" 3>&1 1>&2 2>&3)
			done
			while [[ -z $sspasswd ]]; do
			sspasswd=$(whiptail --passwordbox --nocancel "Put your thinking cap on，快输入你的想要的ss密码并按回车" 8 78  --title "ss passwd input" 3>&1 1>&2 2>&3)
			if [[ $sspasswd == "" ]]; then
			sspasswd=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 40 ; echo '' )
			fi
			done
			ssen=$(whiptail --title "SS encrypt method Menu" --menu --nocancel "Choose an option RTFM: https://www.johnrosen1.com/trojan/" 12 78 3 \
			"1" "aes-128-gcm" \
			"2" "aes-256-gcm" \
			"3" "chacha20-poly1305" 3>&1 1>&2 2>&3)
			case $ssen in
			1)
			ssmethod=aes-128-gcm
			;;
			2)
			ssmethod=aes-256-gcm
			;;
			3)
			ssmethod=chacha20-poly1305
			;;
			esac
		fi
}
###############OS detect####################
osdist(){

set -e
 if cat /etc/*release | grep ^NAME | grep -q CentOS; then
		dist=centos
		pack="yum -y -q"
		yum update -y
		yum install sudo newt curl -y -q
 elif cat /etc/*release | grep ^NAME | grep -q Red; then
		dist=centos
		pack="yum -y -q"
		yum update -y
		yum install sudo newt curl -y -q
 elif cat /etc/*release | grep ^NAME | grep -q Fedora; then
		dist=centos
		pack="yum -y -q"
		yum update -y
		yum install sudo newt curl -y -q
 elif cat /etc/*release | grep ^NAME | grep -q Ubuntu; then
		dist=ubuntu
		pack="apt-get -y -qq"
		apt-get update -q
		apt-get install sudo whiptail curl locales lsb-release -y -qq > /dev/null || true
 elif cat /etc/*release | grep ^NAME | grep -q Debian; then
		dist=debian
		pack="apt-get -y -qq"
		apt-get update -q
		apt-get install sudo whiptail curl locales lsb-release -y -qq > /dev/null || true
 else
	TERM=ansi whiptail --title "OS SUPPORT" --infobox "OS NOT SUPPORTED, couldn't install Trojan-gfw" 8 78
		exit 1;
 fi
}
##############Upgrade system optional########
upgradesystem(){
	if [[ $dist = centos ]]; then
		yum upgrade -y
 elif [[ $dist = ubuntu ]]; then
		export UBUNTU_FRONTEND=noninteractive
		if [[ $ubuntu18_install = 1 ]]; then
					cat > '/etc/apt/sources.list' << EOF
#------------------------------------------------------------------------------#
#                            OFFICIAL UBUNTU REPOS                             #
#------------------------------------------------------------------------------#

###### Ubuntu Main Repos
deb http://us.archive.ubuntu.com/ubuntu/ bionic main restricted universe multiverse 
deb-src http://us.archive.ubuntu.com/ubuntu/ bionic main restricted universe multiverse 

###### Ubuntu Update Repos
deb http://us.archive.ubuntu.com/ubuntu/ bionic-security main restricted universe multiverse 
deb http://us.archive.ubuntu.com/ubuntu/ bionic-updates main restricted universe multiverse 
deb-src http://us.archive.ubuntu.com/ubuntu/ bionic-security main restricted universe multiverse 
deb-src http://us.archive.ubuntu.com/ubuntu/ bionic-updates main restricted universe multiverse 
EOF
		apt-get update
		sh -c 'echo "y\n\ny\ny\ny\ny\ny\ny\ny\n" | DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -q -y' || true
		sh -c 'echo "y\n\ny\ny\ny\ny\ny\ny\ny\n" | DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -q -y' || true
		fi
		sh -c 'echo "y\n\ny\ny\ny\ny\ny\ny\ny\n" | DEBIAN_FRONTEND=noninteractive apt-get upgrade -qq -y' || true
		apt-get autoremove -qq -y
		clear
 elif [[ $dist = debian ]]; then
		export DEBIAN_FRONTEND=noninteractive 
		sh -c 'echo "y\n\ny\ny\ny\ny\ny\ny\ny\n" | DEBIAN_FRONTEND=noninteractive apt-get upgrade -qq -y' || true
		if [[ $debian10_install = 1 ]]; then
					cat > '/etc/apt/sources.list' << EOF
#------------------------------------------------------------------------------#
#                   OFFICIAL DEBIAN REPOS                    
#------------------------------------------------------------------------------#

###### Debian Main Repos
deb http://deb.debian.org/debian/ stable main contrib non-free
deb-src http://deb.debian.org/debian/ stable main contrib non-free

deb http://deb.debian.org/debian/ stable-updates main contrib non-free
deb-src http://deb.debian.org/debian/ stable-updates main contrib non-free

deb http://deb.debian.org/debian-security stable/updates main
deb-src http://deb.debian.org/debian-security stable/updates main

deb http://ftp.debian.org/debian buster-backports main
deb-src http://ftp.debian.org/debian buster-backports main
EOF
		apt-get update
		sh -c 'echo "y\n\ny\ny\ny\ny\ny\ny\ny\n" | DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -q -y' || true
		sh -c 'echo "y\n\ny\ny\ny\ny\ny\ny\ny\n" | DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -q -y' || true
		clear
		fi
		if [[ $debian9_install = 1 ]]; then
					cat > '/etc/apt/sources.list' << EOF
#------------------------------------------------------------------------------#
#                   OFFICIAL DEBIAN REPOS                    
#------------------------------------------------------------------------------#

###### Debian Main Repos
deb http://deb.debian.org/debian/ oldstable main contrib non-free
deb-src http://deb.debian.org/debian/ oldstable main contrib non-free

deb http://deb.debian.org/debian/ oldstable-updates main contrib non-free
deb-src http://deb.debian.org/debian/ oldstable-updates main contrib non-free

deb http://deb.debian.org/debian-security oldstable/updates main
deb-src http://deb.debian.org/debian-security oldstable/updates main

deb http://ftp.debian.org/debian stretch-backports main
deb-src http://ftp.debian.org/debian stretch-backports main
EOF
		apt-get update
		sh -c 'echo "y\n\ny\ny\ny\ny\ny\ny\ny\n" | DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -q -y' || true
		sh -c 'echo "y\n\ny\ny\ny\ny\ny\ny\ny\n" | DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -q -y' || true
		fi
		sh -c 'echo "y\n\ny\ny\ny\ny\ny\ny\ny\n" | DEBIAN_FRONTEND=noninteractive apt-get autoremove -qq -y' || true
		clear
 else
	clear
	TERM=ansi whiptail --title "error can't upgrade system" --infobox "error can't upgrade system" 8 78
		exit 1;
 fi
}
##########install dependencies#############
installdependency(){
		colorEcho ${INFO} "Updating system"
		$pack update
###########################################
	clear
	colorEcho ${INFO} "安装所有必备软件(Install all necessary Software)"
	if [[ $dist = centos ]]; then
		yum install -y -q sudo curl wget gnupg python3-qrcode unzip bind-utils epel-release chrony systemd dbus xz
 elif [[ $dist = ubuntu ]] || [[ $dist = debian ]]; then
		apt-get install sudo curl xz-utils wget apt-transport-https gnupg dnsutils lsb-release python-pil unzip resolvconf ntpdate systemd dbus ca-certificates locales iptables software-properties-common -qq -y
		if [[ $(lsb_release -cs) == xenial ]] || [[ $(lsb_release -cs) == trusty ]] || [[ $(lsb_release -cs) == jessie ]]; then
			TERM=ansi whiptail --title "Skipping generating QR code!" --infobox "你的操作系统不支持 python3-qrcode,Skipping generating QR code!" 8 78
			else
				apt-get install python3-qrcode -qq -y
		fi
 else
	clear
	TERM=ansi whiptail --title "error can't install dependency" --infobox "error can't install dependency" 8 78
		exit 1;
 fi
 clear
#############################################
if [[ -f /etc/trojan/trojan.crt ]] || [[ $dns_api == 1 ]]; then
	:
	else
	if isresolved $domain
	then
	:
	else
	clear
	whiptail --title "Domain verification fail" --msgbox --scrolltext "域名解析验证失败，请自行验证解析是否成功并且请关闭Cloudfalare CDN并检查VPS控制面板防火墙(80 443)是否打开!!!Domain verification fail,Pleae turn off Cloudflare CDN and Open port 80 443 on VPS panel !!!" 8 78
	colorEcho ${ERROR} "域名解析验证失败，请自行验证解析是否成功并且请关闭Cloudfalare CDN并检查VPS控制面板防火墙(80 443)是否打开!!!"
	colorEcho ${ERROR} "Domain verification fail,Pleae turn off Cloudflare CDN and Open port 80 443 on VPS panel !!!"
	exit -1
	clear
	fi  
fi
#############################################
if [[ $system_upgrade = 1 ]]; then
upgradesystem
fi
clear
#############################################
if [[ $tls13only = 1 ]]; then
cipher_server="TLS_AES_128_GCM_SHA256"
fi
#####################################################
	if [[ -f /etc/apt/sources.list.d/nginx.list ]] || [[ -f /usr/sbin/nginx ]]; then
		:
		else
			clear
			colorEcho ${INFO} "安装Nginx(Install Nginx ing)"
	if [[ $dist = centos ]]; then
	yum install nginx -y -q
	systemctl stop nginx || true
 elif [[ $dist = debian ]] || [[ $dist = ubuntu ]]; then
	wget https://nginx.org/keys/nginx_signing.key -q
	apt-key add nginx_signing.key
	rm -rf nginx_signing.key
	touch /etc/apt/sources.list.d/nginx.list
	cat > '/etc/apt/sources.list.d/nginx.list' << EOF
deb https://nginx.org/packages/mainline/$dist/ $(lsb_release -cs) nginx
deb-src https://nginx.org/packages/mainline/$dist/ $(lsb_release -cs) nginx
EOF
	apt-get remove nginx-common -qq -y
	apt-get update -qq
	apt-get install nginx -qq -y
 else
	clear
	TERM=ansi whiptail --title "error can't install nginx" --infobox "error can't install nginx" 8 78
		exit 1;
 fi
fi
	cat > '/lib/systemd/system/nginx.service' << EOF
[Unit]
Description=The NGINX HTTP and reverse proxy server
After=syslog.target network.target remote-fs.target nss-lookup.target

[Service]
Type=forking
PIDFile=/run/nginx.pid
ExecStartPre=/usr/sbin/nginx -t
ExecStart=/usr/sbin/nginx
ExecReload=/usr/sbin/nginx -s reload
ExecStop=/bin/kill -s QUIT $MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
if [[ $dist = centos ]]; then
	wget https://raw.githubusercontent.com/johnrosen1/trojan-gfw-script/master/nginx_centos -q
	cp -f nginx_centos /usr/sbin/nginx
	rm nginx_centos
	mkdir /var/cache/nginx/ || true
	chmod +x /usr/sbin/nginx || true
fi
		cat > '/etc/nginx/nginx.conf' << EOF
user nginx;
worker_processes auto;

error_log /var/log/nginx/error.log warn;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;
events {
	worker_connections 3000;
	use epoll;
	multi_accept on;
}

http {
	aio threads;
	charset UTF-8;
	tcp_nodelay on;
	tcp_nopush on;
	server_tokens off;

	include /etc/nginx/mime.types;
	default_type application/octet-stream;

	access_log /var/log/nginx/access.log;


	log_format  main  '\$remote_addr - \$remote_user [\$time_local] "\$request" '
		'\$status $body_bytes_sent "\$http_referer" '
		'"\$http_user_agent" "\$http_x_forwarded_for"';

	sendfile on;
	gzip on;
	gzip_comp_level 8;

	include /etc/nginx/conf.d/*.conf;
	client_max_body_size 10G;
}
EOF
clear
#############################################
if [[ $install_qbt = 1 ]]; then
	if [[ -f /usr/bin/qbittorrent-nox ]]; then
		:
		else
		clear
		colorEcho ${INFO} "安装Qbittorrent(Install Qbittorrent ing)"
	if [[ $dist = centos ]]; then
	yum install -y -q epel-release
	yum update -y -q
	yum install qbittorrent-nox -y -q || true
 elif [[ $dist = ubuntu ]]; then
		export DEBIAN_FRONTEND=noninteractive
		add-apt-repository ppa:qbittorrent-team/qbittorrent-stable -y
		apt-get install qbittorrent-nox -qq -y
 elif [[ $dist = debian ]]; then
		export DEBIAN_FRONTEND=noninteractive 
		apt-get install qbittorrent-nox -qq -y
 else
	clear
	TERM=ansi whiptail --title "error can't install qbittorrent-nox" --infobox "error can't install qbittorrent-nox" 8 78
		exit 1;
 fi
			cat > '/etc/systemd/system/qbittorrent.service' << EOF
[Unit]
Description=qBittorrent Daemon Service
Documentation=man:qbittorrent-nox(1)
Wants=network-online.target
After=network-online.target nss-lookup.target

[Service]
# if you have systemd >= 240, you probably want to use Type=exec instead
Type=simple
User=root
ExecStart=/usr/bin/qbittorrent-nox
TimeoutStopSec=infinity
Restart=on-failure
RestartSec=3s

[Install]
WantedBy=multi-user.target
EOF
mkdir /usr/share/nginx/qbt/
chmod 755 /usr/share/nginx/qbt/
fi
fi
clear
#############################################
if [[ $install_tracker = 1 ]]; then
	if [[ -f /usr/bin/bittorrent-tracker ]]; then
		:
		else
			clear
			colorEcho ${INFO} "安装Bittorrent-tracker(Install bittorrent-tracker ing)"
	if [[ $dist = centos ]]; then
		curl -sL https://rpm.nodesource.com/setup_13.x | bash -
		yum install -y -q nodejs
 elif [[ $dist = ubuntu ]]; then
		export DEBIAN_FRONTEND=noninteractive
		curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash -
		apt-get install -qq -y nodejs
 elif [[ $dist = debian ]]; then
		export DEBIAN_FRONTEND=noninteractive 
		curl -sL https://deb.nodesource.com/setup_13.x | bash -
		apt-get install -qq -y nodejs
 else
	clear
	TERM=ansi whiptail --title "error can't install qbittorrent-nox" --infobox "error can't install qbittorrent-nox" 8 78
		exit 1;
 fi
 npm install -g bittorrent-tracker --silent
			cat > '/etc/systemd/system/tracker.service' << EOF
[Unit]
Description=Bittorrent-Tracker Daemon Service
Wants=network-online.target
After=network-online.target nss-lookup.target

[Service]
# if you have systemd >= 240, you probably want to use Type=exec instead
Type=simple
User=root
RemainAfterExit=yes
ExecStart=/usr/bin/bittorrent-tracker --http --ws --trust-proxy
TimeoutStopSec=infinity
Restart=on-failure
RestartSec=3s

[Install]
WantedBy=multi-user.target
EOF
fi
fi
clear
#############################################
if [[ $install_file = 1 ]]; then
	if [[ -f /usr/local/bin/filebrowser ]]; then
		:
		else
			clear
			colorEcho ${INFO} "安装Filebrowser(Install Filebrowser ing)"
	if [[ $dist = centos ]]; then
	curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash || true
 elif [[ $dist = ubuntu ]] || [[ $dist = debian ]]; then
		export DEBIAN_FRONTEND=noninteractive
		curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash
 else
	clear
	TERM=ansi whiptail --title "error can't install filebrowser" --infobox "error can't install filebrowser" 8 78
		exit 1;
 fi
			 cat > '/etc/systemd/system/filebrowser.service' << EOF
[Unit]
Description=filebrowser browser
After=network.target

[Service]
User=root
Group=root
ExecStart=/usr/local/bin/filebrowser -r /usr/share/nginx/ -d /etc/filebrowser/database.db -b $filepath -p 8081
ExecReload=/usr/bin/kill -HUP \$MAINPID
ExecStop=/usr/bin/kill -s STOP \$MAINPID
RestartSec=3s
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
mkdir /etc/filebrowser/
touch /etc/filebrowser/database.db
fi
fi
clear
#############################################
if [[ $install_aria = 1 ]]; then
	if [[ -f /usr/local/bin/aria2c ]]; then
		:
		else
			clear
			colorEcho ${INFO} "安装aria2(Install aria2 ing)"
			if [[ $dist = centos ]]; then
			yum install -y -q nettle-dev libgmp-dev libssh2-1-dev libc-ares-dev libxml2-dev zlib1g-dev libsqlite3-dev pkg-config libssl-dev libtool libuv1-dev libcppunit-dev || true
			wget https://raw.githubusercontent.com/johnrosen1/trojan-gfw-script/master/aria2c_centos.xz -q 
			xz --decompress aria2c_centos.xz
			cp aria2c_centos /usr/local/bin/aria2c
			chmod +x /usr/local/bin/aria2c
			rm aria2c_centos
				else
			apt-get install nettle-dev libgmp-dev libssh2-1-dev libc-ares-dev libxml2-dev zlib1g-dev libsqlite3-dev pkg-config libssl-dev libtool libuv1-dev libcppunit-dev -qq -y
			wget https://raw.githubusercontent.com/johnrosen1/trojan-gfw-script/master/aria2c.xz -q 
			xz --decompress aria2c.xz
			cp aria2c /usr/local/bin/aria2c
			chmod +x /usr/local/bin/aria2c
			rm aria2c
			#apt-get install build-essential nettle-dev libgmp-dev libssh2-1-dev libc-ares-dev libxml2-dev zlib1g-dev libsqlite3-dev pkg-config libssl-dev autoconf automake autotools-dev autopoint libtool libuv1-dev libcppunit-dev -qq -y
			#wget https://github.com/aria2/aria2/releases/download/release-1.35.0/aria2-1.35.0.tar.xz -q
			#cd aria2-1.35.0
			#./configure --without-gnutls --with-openssl
			#make -j $(nproc --all)
			#make install
			#apt remove build-essential autoconf automake autotools-dev autopoint libtool -qq -y
			apt-get autoremove -qq -y
			fi
			touch /usr/local/bin/aria2.session
			mkdir /usr/share/nginx/aria2/
			chmod 755 /usr/share/nginx/aria2/
			cd ..
			rm -rf aria2-1.35.0
			cat > '/etc/systemd/system/aria2.service' << EOF
[Unit]
Description=Aria2c download manager
Requires=network.target
After=network.target
		
[Service]
Type=forking
User=root
RemainAfterExit=yes
ExecStart=/usr/local/bin/aria2c --conf-path=/etc/aria2.conf --daemon
ExecReload=/usr/bin/kill -HUP \$MAINPID
ExecStop=/usr/bin/kill -s STOP \$MAINPID
RestartSec=1min
Restart=on-failure
		
[Install]
WantedBy=multi-user.target
EOF
			cat > '/etc/aria2.conf' << EOF
#rpc-secure=true
#rpc-certificate=/etc/trojan/trojan.crt
#rpc-private-key=/etc/trojan/trojan.key
## 下载设置 ##
continue=true
max-concurrent-downloads=50
split=16
min-split-size=10M
max-connection-per-server=16
lowest-speed-limit=0
#max-overall-download-limit=0
#max-download-limit=0
#max-overall-upload-limit=0
#max-upload-limit=0
disable-ipv6=false
max-tries=0
#retry-wait=0

## 进度保存相关 ##

input-file=/usr/local/bin/aria2.session
save-session=/usr/local/bin/aria2.session
save-session-interval=60
force-save=true

## RPC相关设置 ##

enable-rpc=true
rpc-allow-origin-all=true
rpc-listen-all=false
event-poll=epoll
# RPC监听端口, 端口被占用时可以修改, 默认:6800
rpc-listen-port=6800
# 设置的RPC授权令牌, v1.18.4新增功能, 取代 --rpc-user 和 --rpc-passwd 选项
rpc-secret=$ariapasswd

## BT/PT下载相关 ##
#follow-torrent=true
listen-port=51413
#bt-max-peers=55
enable-dht=true
enable-dht6=true
#dht-listen-port=6881-6999
bt-enable-lpd=true
#enable-peer-exchange=true
#bt-request-peer-speed-limit=50K
# 客户端伪装, PT需要
#peer-id-prefix=-TR2770-
#user-agent=Transmission/2.77
seed-ratio=0
# BT校验相关, 默认:true
#bt-hash-check-seed=true
bt-seed-unverified=true
bt-save-metadata=true
bt-require-crypto=true

## 磁盘相关 ##

#文件保存路径, 默认为当前启动位置
dir=/usr/share/nginx/aria2/
#enable-mmap=true
file-allocation=none
disk-cache=64M
EOF
	fi
fi
#############################################
if [[ $dnsmasq_install = 1 ]]; then
	if [[ -f /usr/sbin/dnsmasq ]]; then
		:
		else
			clear
			colorEcho ${INFO} "安装dnsmasq(Install dnsmasq ing)"
		if [[ $dist = centos ]]; then
		yum install -y -q dnsmasq  || true
 elif [[ $dist = ubuntu ]] || [[ $dist = debian ]]; then
		export DEBIAN_FRONTEND=noninteractive
		apt-get install dnsmasq -qq -y || true
 else
	clear
	TERM=ansi whiptail --title "error can't install dnsmasq" --infobox "error can't install dnsmasq" 8 78
		exit 1;
 fi
 if [[ $dist = ubuntu ]]; then
	 systemctl stop systemd-resolved || true
	 systemctl disable systemd-resolved || true > /dev/null
 fi
 touch /etc/dnsmasq.txt || true
			cat > '/etc/dnsmasq.txt' << EOF
####Block 360####
0.0.0.0 360.cn
0.0.0.0 360.com
0.0.0.0 360jie.com
0.0.0.0 360kan.com
0.0.0.0 360taojin.com
0.0.0.0 i360mall.com
0.0.0.0 qhimg.com
0.0.0.0 qhmsg.com
0.0.0.0 qhres.com
0.0.0.0 qihoo.com
0.0.0.0 nicaifu.com
0.0.0.0 so.com
####Block Xunlei###
0.0.0.0 xunlei.com
####Block Baidu###
0.0.0.0 baidu.cn
0.0.0.0 baidu.com
0.0.0.0 baiducontent.com
0.0.0.0 baidupcs.com
0.0.0.0 baidustatic.com
0.0.0.0 baifubao.com
0.0.0.0 bdimg.com
0.0.0.0 bdstatic.com
0.0.0.0 duapps.com
0.0.0.0 quyaoya.com
0.0.0.0 tiebaimg.com
0.0.0.0 xiaodutv.com
0.0.0.0 sina.com
EOF
		 cat > '/etc/dnsmasq.conf' << EOF
port=53
domain-needed
bogus-priv
no-resolv
server=8.8.4.4#53
server=1.1.1.1#53
addn-hosts=/etc/dnsmasq.txt
address=/cn/0.0.0.0
interface=lo
bind-interfaces
cache-size=10000
no-negcache
log-queries 
log-facility=/var/log/dnsmasq.log 
EOF
echo "nameserver 127.0.0.1" > '/etc/resolv.conf'
systemctl restart dnsmasq || true
systemctl enable dnsmasq || true      
	fi
fi
clear
#############################################
if [[ $install_v2ray = 1 ]] || [[ $install_ss = 1 ]]; then
	clear
	installv2ray
fi
#############################################
if [[ $install_tor = 1 ]]; then
	clear
	if [[ -f /usr/bin/tor ]]; then
		:
		else
			colorEcho ${INFO} "安装Tor(Install Tor Relay ing)"
	if [[ $dist = centos ]]; then
		yum install -y -q epel-release || true
		yum install -y -q tor  || true
 elif [[ $dist = ubuntu ]] || [[ $dist = debian ]]; then
		export DEBIAN_FRONTEND=noninteractive
		touch /etc/apt/sources.list.d/tor.list
		cat > '/etc/apt/sources.list.d/tor.list' << EOF
deb https://deb.torproject.org/torproject.org $(lsb_release -cs) main
deb-src https://deb.torproject.org/torproject.org $(lsb_release -cs) main
EOF
		curl https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --import
		gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -
		apt-get update
		apt-get install deb.torproject.org-keyring tor tor-arm tor-geoipdb -qq -y || true
		service tor stop
 else
	clear
	TERM=ansi whiptail --title "error can't install tor" --infobox "error can't install tor" 8 78
		exit 1;
 fi
			 cat > '/etc/tor/torrc' << EOF
SocksPort 0
RunAsDaemon 1
ORPort 9001
#ORPort [$myipv6]:9001
Nickname $tor_name
ContactInfo $domain [tor-relay.co]
Log notice file /var/log/tor/notices.log
DirPort 9030
ExitPolicy reject6 *:*, reject *:*
EOF
service tor start
systemctl restart tor@default
	fi
fi
#############################################
if [[ $install_netdata = 1 ]]; then
	if [[ -f /usr/sbin/netdata ]]; then
		:
		else
			clear
			colorEcho ${INFO} "安装Netdata(Install netdata ing)"
			bash <(curl -Ss https://my-netdata.io/kickstart.sh) --dont-wait --disable-telemetry
			sed -i 's/# bind to = \*/bind to = 127.0.0.1/g' /etc/netdata/netdata.conf
			systemctl restart netdata
	fi
fi
clear
#############################################
if [[ -f /etc/trojan/trojan.crt ]]; then
	:
	else
	curl -s https://get.acme.sh | sh
	~/.acme.sh/acme.sh --upgrade --auto-upgrade  
fi
#############################################
if [[ $install_trojan = 1 ]]; then
	if [[ -f /usr/local/bin/trojan ]]; then
		:
		else
	clear
	colorEcho ${INFO} "安装Trojan-GFW(Install Trojan-GFW ing)"
	bash -c "$(curl -fsSL https://raw.githubusercontent.com/trojan-gfw/trojan-quickstart/master/trojan-quickstart.sh)"
	systemctl daemon-reload
	clear
	colorEcho ${INFO} "配置(configing) trojan-gfw"
	if [[ -f /etc/trojan/trojan.pem ]]; then
		colorEcho ${INFO} "DH已有，跳过生成。。。"
		else
			:
			#openssl dhparam -out /etc/trojan/trojan.pem 2048
	fi
	cat > '/usr/local/etc/trojan/config.json' << EOF
{
		"run_type": "server",
		"local_addr": "::",
		"local_port": 443,
		"remote_addr": "127.0.0.1",
		"remote_port": 80,
		"password": [
				"$password1",
				"$password2"
		],
		"log_level": 1,
		"ssl": {
				"cert": "/etc/trojan/trojan.crt",
				"key": "/etc/trojan/trojan.key",
				"key_password": "",
				"cipher": "$cipher_server",
				"cipher_tls13": "TLS_AES_128_GCM_SHA256:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_256_GCM_SHA384",
				"prefer_server_cipher": true,
				"alpn": [
						"http/1.1"
				],
				"reuse_session": true,
				"session_ticket": false,
				"session_timeout": 600,
				"plain_http_response": "",
				"curves": "",
				"dhparam": ""
		},
		"tcp": {
				"prefer_ipv4": false,
				"no_delay": true,
				"keep_alive": true,
				"reuse_port": false,
				"fast_open": true,
				"fast_open_qlen": 20
		},
		"mysql": {
				"enabled": false,
				"server_addr": "127.0.0.1",
				"server_port": 3306,
				"database": "trojan",
				"username": "trojan",
				"password": ""
		}
}
EOF
	mkdir /etc/trojan || true
	touch /etc/trojan/client1.json
	touch /etc/trojan/client2.json
		cat > '/etc/trojan/client1.json' << EOF
{
		"run_type": "client",
		"local_addr": "127.0.0.1",
		"local_port": 1080,
		"remote_addr": "$myip",
		"remote_port": 443,
		"password": [
				"$password1"
		],
		"log_level": 1,
		"ssl": {
				"verify": true,
				"verify_hostname": true,
				"cert": "",
				"cipher": "$cipher_client",
				"cipher_tls13": "TLS_AES_128_GCM_SHA256:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_256_GCM_SHA384",
				"sni": "$domain",
				"alpn": [
						"h2",
						"http/1.1"
				],
				"reuse_session": true,
				"session_ticket": false,
				"curves": ""
		},
		"tcp": {
				"no_delay": true,
				"keep_alive": true,
				"reuse_port": false,
				"fast_open": false,
				"fast_open_qlen": 20
		}
}
EOF
		cat > '/etc/trojan/client2.json' << EOF
{
		"run_type": "client",
		"local_addr": "127.0.0.1",
		"local_port": 1080,
		"remote_addr": "$myip",
		"remote_port": 443,
		"password": [
				"$password2"
		],
		"log_level": 1,
		"ssl": {
				"verify": true,
				"verify_hostname": true,
				"cert": "",
				"cipher": "$cipher_client",
				"cipher_tls13": "TLS_AES_128_GCM_SHA256:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_256_GCM_SHA384",
				"sni": "$domain",
				"alpn": [
						"h2",
						"http/1.1"
				],
				"reuse_session": true,
				"session_ticket": false,
				"curves": ""
		},
		"tcp": {
				"no_delay": true,
				"keep_alive": true,
				"reuse_port": false,
				"fast_open": false,
				"fast_open_qlen": 20
		}
}
EOF
	fi
fi
	clear
	if [[ $install_bbr = 1 ]]; then
			colorEcho ${INFO} "设置(setting up) TCP-BBR boost technology"
	cat > '/etc/sysctl.d/99-sysctl.conf' << EOF
net.ipv6.conf.all.accept_ra = 2
#fs.file-max = 51200
net.core.rmem_max = 67108864
net.core.wmem_max = 67108864
net.core.rmem_default = 65536
net.core.wmem_default = 65536
net.core.netdev_max_backlog = 4096
net.core.somaxconn = 4096
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.ip_local_port_range = 10000 65000
net.ipv4.tcp_max_tw_buckets = 5000
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_rmem = 4096 87380 67108864
net.ipv4.tcp_wmem = 4096 65536 67108864
net.ipv4.tcp_mtu_probing = 1
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_max_syn_backlog = 12800
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
EOF
	sysctl -p > /dev/null || true

		cat > '/etc/systemd/system.conf' << EOF
[Manager]
#DefaultTimeoutStartSec=90s
DefaultTimeoutStopSec=30s
#DefaultRestartSec=100ms
DefaultLimitCORE=infinity
DefaultLimitNOFILE=51200
DefaultLimitNPROC=51200
EOF
		cat > '/etc/security/limits.conf' << EOF
* soft nofile 51200
* hard nofile 51200
EOF
if grep -q "ulimit" /etc/profile
then
	:
else
echo "ulimit -SHn 51200" >> /etc/profile
fi
if grep -q "pam_limits.so" /etc/pam.d/common-session
then
	:
else
echo "session required pam_limits.so" >> /etc/pam.d/common-session || true
fi
systemctl daemon-reload
	fi
	if [[ $install_bbrplus = 1 ]]; then
		bash -c "$(curl -fsSL https://raw.githubusercontent.com/chiakge/Linux-NetSpeed/master/tcp.sh)"
	fi
	timedatectl set-timezone Asia/Hong_Kong || true
	timedatectl set-ntp on || true
	if [[ $dist = centos ]]; then
		:
		else
			ntpdate -qu 1.hk.pool.ntp.org > /dev/null || true
	fi
}
#########Open ports########################
openfirewall(){
	colorEcho ${INFO} "设置 firewall"
	#sh -c 'echo "1\n" | DEBIAN_FRONTEND=noninteractive update-alternatives --config iptables'
	iptables -I INPUT -p tcp -m tcp --dport 443 -j ACCEPT || true
	iptables -I INPUT -p tcp -m tcp --dport 80 -j ACCEPT || true
	iptables -I OUTPUT -j ACCEPT || true
	ip6tables -I INPUT -p tcp -m tcp --dport 443 -j ACCEPT || true
	ip6tables -I INPUT -p tcp -m tcp --dport 80 -j ACCEPT || true
	ip6tables -I OUTPUT -j ACCEPT || true
	if [[ $dist = centos ]]; then
			setenforce 0  || true
					cat > '/etc/selinux/config' << EOF
SELINUX=disabled
SELINUXTYPE=targeted
EOF
		firewall-cmd --zone=public --add-port=80/tcp --permanent  || true
		firewall-cmd --zone=public --add-port=443/tcp --permanent  || true
		systemctl stop firewalld || true
		systemctl disable firewalld || true
 elif [[ $dist = ubuntu ]]; then
		export DEBIAN_FRONTEND=noninteractive
		apt-get install iptables-persistent -qq -y > /dev/null || true
 elif [[ $dist = debian ]]; then
		export DEBIAN_FRONTEND=noninteractive 
		apt-get install iptables-persistent -qq -y > /dev/null || true
 else
	clear
	TERM=ansi whiptail --title "error can't install iptables-persistent" --infobox "error can't install iptables-persistent" 8 78
		exit 1;
 fi
}
##################################################
issuecert(){
	clear
	colorEcho ${INFO} "申请(issuing) let\'s encrypt certificate"
	if [[ -f /etc/trojan/trojan.crt ]]; then
		myip=`curl -s http://dynamicdns.park-your-domain.com/getip`
		TERM=ansi whiptail --title "证书已有，跳过申请" --infobox "证书已有，跳过申请。。。" 8 78
		else
	mkdir /etc/trojan/ || true &
	rm -rf /etc/nginx/sites-available/* &
	rm -rf /etc/nginx/sites-enabled/* &
	rm -rf /etc/nginx/conf.d/*
	touch /etc/nginx/conf.d/default.conf
		cat > '/etc/nginx/conf.d/default.conf' << EOF
server {
		listen       80;
		listen       [::]:80;
		server_name  $domain;
		root   /usr/share/nginx/html;
}
EOF
	nginx -t
	systemctl start nginx || true
	if [[ $dns_api == 1 ]]; then
		if [[ $cf_api == 1 ]]; then
		~/.acme.sh/acme.sh --issue --dns dns_cf -d $domain -k ec-256 --force --log --reloadcmd "systemctl reload trojan || true"
		elif [[ $namesilo_api == 1 ]]; then
		~/.acme.sh/acme.sh --issue --dns dns_namesilo --dnssleep 900 -d $domain -k ec-256 --force --log --reloadcmd "systemctl reload trojan || true"
		elif [[ $ali_api == 1 ]]; then
		~/.acme.sh/acme.sh --issue --dns dns_ali -d $domain -k ec-256 --force --log --reloadcmd "systemctl reload trojan || true"
		fi
		else
		~/.acme.sh/acme.sh --issue --nginx -d $domain -k ec-256 --force --log --reloadcmd "systemctl reload trojan || true"  
	fi
	~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/trojan/trojan.crt --keypath /etc/trojan/trojan.key --ecc
	chmod +r /etc/trojan/trojan.key
	fi
}
########Nginx config for Trojan only##############
nginxtrojan(){
	clear
	colorEcho ${INFO} "配置(configing) nginx"
rm -rf /etc/nginx/sites-available/* || true
rm -rf /etc/nginx/sites-enabled/* || true
rm -rf /etc/nginx/conf.d/* || true
touch /etc/nginx/conf.d/trojan.conf
if [[ $install_trojan = 1 ]]; then
	cat > '/etc/nginx/conf.d/trojan.conf' << EOF
server {
	listen 127.0.0.1:80;
		server_name $domain;
		if (\$http_user_agent = "") { return 444; }
		if (\$host != "$domain") { return 404; }
		add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload" always;
		add_header X-Frame-Options SAMEORIGIN always;
		add_header X-Content-Type-Options "nosniff" always;
		add_header Referrer-Policy "no-referrer";
		#add_header Content-Security-Policy "default-src 'self'; script-src 'self' https://ssl.google-analytics.com https://assets.zendesk.com https://connect.facebook.net; img-src 'self' https://ssl.google-analytics.com https://s-static.ak.facebook.com https://assets.zendesk.com; style-src 'self' https://fonts.googleapis.com https://assets.zendesk.com; font-src 'self' https://themes.googleusercontent.com; frame-src https://assets.zendesk.com https://www.facebook.com https://s-static.ak.facebook.com https://tautt.zendesk.com; object-src 'none'";
		add_header Feature-Policy "geolocation none;midi none;notifications none;push none;sync-xhr none;microphone none;camera none;magnetometer none;gyroscope none;speaker self;vibrate none;fullscreen self;payment none;";
		location / {
			root /usr/share/nginx/html/;
				index index.html;
				}
EOF
	else
	cat > '/etc/nginx/conf.d/trojan.conf' << EOF
server {
		listen 443 ssl http2;
		listen [::]:443 ssl http2;

		ssl_certificate       /etc/trojan/trojan.crt;
		ssl_certificate_key   /etc/trojan/trojan.key;
		ssl_protocols         TLSv1.3 TLSv1.2;
		ssl_ciphers $cipher_server;
		ssl_prefer_server_ciphers off;
		ssl_early_data on;
		ssl_session_cache   shared:SSL:40m;
		ssl_session_timeout 1d;
		ssl_session_tickets off;
		ssl_stapling on;
		ssl_stapling_verify on;
		#ssl_dhparam /etc/nginx/nginx.pem;

		resolver 1.1.1.1;
		resolver_timeout 10s;
		server_name           $domain;
		#add_header alt-svc 'quic=":443"; ma=2592000; v="46"';
		add_header X-Frame-Options SAMEORIGIN always;
		add_header X-Content-Type-Options "nosniff" always;
		add_header X-XSS-Protection "1; mode=block" always;
		add_header Referrer-Policy "no-referrer";
		add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload" always;
		#add_header Content-Security-Policy "default-src 'self'; script-src 'self' https://ssl.google-analytics.com https://assets.zendesk.com https://connect.facebook.net; img-src 'self' https://ssl.google-analytics.com https://s-static.ak.facebook.com https://assets.zendesk.com; style-src 'self' https://fonts.googleapis.com https://assets.zendesk.com; font-src 'self' https://themes.googleusercontent.com; frame-src https://assets.zendesk.com https://www.facebook.com https://s-static.ak.facebook.com https://tautt.zendesk.com; object-src 'none'";
		add_header Feature-Policy "geolocation none;midi none;notifications none;push none;sync-xhr none;microphone none;camera none;magnetometer none;gyroscope none;speaker self;vibrate none;fullscreen self;payment none;";
		if (\$http_user_agent = "") { return 444; }
		if (\$host != "$domain") { return 404; }
				location / {
						root /usr/share/nginx/html;
						index index.html;
				}
EOF
fi
if [[ $install_v2ray = 1 ]]; then
echo "    location $path {" >> /etc/nginx/conf.d/trojan.conf
echo "        #access_log off;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_redirect off;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_intercept_errors on;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_pass http://127.0.0.1:10000;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_http_version 1.1;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header Upgrade \$http_upgrade;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header Connection "upgrade";" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header Host \$http_host;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header X-Real-IP \$remote_addr;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;" >> /etc/nginx/conf.d/trojan.conf
echo "        error_page 502 = @errpage;" >> /etc/nginx/conf.d/trojan.conf
echo "        }" >> /etc/nginx/conf.d/trojan.conf
fi
if [[ $install_ss = 1 ]]; then
echo "    location $sspath {" >> /etc/nginx/conf.d/trojan.conf
echo "        #access_log off;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_redirect off;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_intercept_errors on;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_pass http://127.0.0.1:20000;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_http_version 1.1;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header Upgrade \$http_upgrade;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header Connection "upgrade";" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header Host \$http_host;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header X-Real-IP \$remote_addr;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;" >> /etc/nginx/conf.d/trojan.conf
echo "        error_page 502 = @errpage;" >> /etc/nginx/conf.d/trojan.conf
echo "        }" >> /etc/nginx/conf.d/trojan.conf
fi
if [[ $install_aria = 1 ]]; then
echo "    location $ariapath {" >> /etc/nginx/conf.d/trojan.conf
echo "        #access_log off;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_redirect off;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_intercept_errors on;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_pass http://127.0.0.1:6800/jsonrpc;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_http_version 1.1;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header Upgrade \$http_upgrade;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header Connection "upgrade";" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header Host \$http_host;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header X-Real-IP \$remote_addr;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;" >> /etc/nginx/conf.d/trojan.conf
echo "        error_page 502 = @errpage;" >> /etc/nginx/conf.d/trojan.conf
echo "        }" >> /etc/nginx/conf.d/trojan.conf
fi
if [[ $install_qbt = 1 ]]; then
echo "    location $qbtpath {" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_pass              http://127.0.0.1:8080/;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header        X-Forwarded-Host        \$server_name:\$server_port;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_hide_header       Referer;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_hide_header       Origin;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header        Referer                 '';" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header        Origin                  '';" >> /etc/nginx/conf.d/trojan.conf
echo "        # add_header              X-Frame-Options         "SAMEORIGIN"; # not needed since 4.1.0" >> /etc/nginx/conf.d/trojan.conf
echo "        }" >> /etc/nginx/conf.d/trojan.conf
fi
if [[ $install_file = 1 ]]; then
echo "    location $filepath {" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_pass http://127.0.0.1:8081/;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_intercept_errors on;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_http_version 1.1;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header Upgrade \$http_upgrade;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header Connection "upgrade";" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header Host \$http_host;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header X-Real-IP \$remote_addr;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;" >> /etc/nginx/conf.d/trojan.conf
echo "        error_page 502 = @errpage;" >> /etc/nginx/conf.d/trojan.conf
echo "        }" >> /etc/nginx/conf.d/trojan.conf
fi
if [[ $install_tracker = 1 ]]; then
echo "    location $trackerpath {" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_pass http://127.0.0.1:8000/announce;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_intercept_errors on;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_http_version 1.1;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header Upgrade \$http_upgrade;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header Connection "upgrade";" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header Host \$http_host;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header X-Real-IP \$remote_addr;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;" >> /etc/nginx/conf.d/trojan.conf
echo "        error_page 502 = @errpage;" >> /etc/nginx/conf.d/trojan.conf
echo "        }" >> /etc/nginx/conf.d/trojan.conf
echo "    location $trackerstatuspath {" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_pass http://127.0.0.1:8000/stats;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_intercept_errors on;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_http_version 1.1;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header Upgrade \$http_upgrade;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header Connection "upgrade";" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header Host \$http_host;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header X-Real-IP \$remote_addr;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;" >> /etc/nginx/conf.d/trojan.conf
echo "        error_page 502 = @errpage;" >> /etc/nginx/conf.d/trojan.conf
echo "        }" >> /etc/nginx/conf.d/trojan.conf
fi
if [[ $install_netdata = 1 ]]; then
echo "    location ~ $netdatapath(?<ndpath>.*) {" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_redirect off;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header Host \$host;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header X-Forwarded-Host \$host;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header X-Forwarded-Server \$host;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_http_version 1.1;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_pass_request_headers on;" >> /etc/nginx/conf.d/trojan.conf
echo '        proxy_set_header Connection "keep-alive";' >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_store off;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_pass http://netdata/\$ndpath\$is_args\$args;" >> /etc/nginx/conf.d/trojan.conf
echo "        gzip on;" >> /etc/nginx/conf.d/trojan.conf
echo "        gzip_proxied any;" >> /etc/nginx/conf.d/trojan.conf
echo "        gzip_types *;" >> /etc/nginx/conf.d/trojan.conf
echo "        }" >> /etc/nginx/conf.d/trojan.conf
fi
echo "        location @errpage {" >> /etc/nginx/conf.d/trojan.conf
echo "        return 404;" >> /etc/nginx/conf.d/trojan.conf
echo "        }" >> /etc/nginx/conf.d/trojan.conf
echo "}" >> /etc/nginx/conf.d/trojan.conf
echo "" >> /etc/nginx/conf.d/trojan.conf
echo "server {" >> /etc/nginx/conf.d/trojan.conf
echo "    listen 80;" >> /etc/nginx/conf.d/trojan.conf
echo "    listen [::]:80;" >> /etc/nginx/conf.d/trojan.conf
echo "    server_name $domain;" >> /etc/nginx/conf.d/trojan.conf
echo "    return 301 https://$domain;" >> /etc/nginx/conf.d/trojan.conf
echo "}" >> /etc/nginx/conf.d/trojan.conf
echo "" >> /etc/nginx/conf.d/trojan.conf
echo "server {" >> /etc/nginx/conf.d/trojan.conf
echo "    listen 80 default_server;" >> /etc/nginx/conf.d/trojan.conf
echo "    listen [::]:80 default_server;" >> /etc/nginx/conf.d/trojan.conf
echo "    server_name _;" >> /etc/nginx/conf.d/trojan.conf
echo "    return 444;" >> /etc/nginx/conf.d/trojan.conf
echo "}" >> /etc/nginx/conf.d/trojan.conf
if [[ $install_netdata = 1 ]]; then
	echo "upstream netdata {" >> /etc/nginx/conf.d/trojan.conf
	echo "    server 127.0.0.1:19999;" >> /etc/nginx/conf.d/trojan.conf
	echo "    keepalive 64;" >> /etc/nginx/conf.d/trojan.conf
	echo "}" >> /etc/nginx/conf.d/trojan.conf
fi
nginx -t
systemctl restart nginx || true
htmlcode=$(shuf -i 1-3 -n 1)
wget https://raw.githubusercontent.com/johnrosen1/trojan-gfw-script/master/$htmlcode.zip -q
unzip -o $htmlcode.zip -d /usr/share/nginx/html/ > /dev/null
rm -rf $htmlcode.zip
}
##########Auto boot start###############
start(){
	colorEcho ${INFO} "启动(starting) trojan-gfw and nginx ing..."
	systemctl daemon-reload || true
	if [[ $install_qbt = 1 ]]; then
		systemctl start qbittorrent.service || true
	fi
	if [[ $install_tracker = 1 ]]; then
		systemctl start tracker || true
	fi
	if [[ $install_file = 1 ]]; then
		systemctl start filebrowser || true
	fi
	if [[ $install_aria = 1 ]]; then
		systemctl start aria2 || true
	fi
	if [[ $install_v2ray = 1 ]] || [[ $install_ss = 1 ]]; then
		systemctl start v2ray || true
	fi
	if [[ $install_trojan = 1 ]]; then
		systemctl start trojan || true
	fi
	systemctl restart nginx || true
}
bootstart(){
	colorEcho ${INFO} "设置开机自启(auto boot start) ing..."
	systemctl daemon-reload || true
	if [[ $install_qbt = 1 ]]; then
		systemctl enable qbittorrent.service || true
	fi
	if [[ $install_tracker = 1 ]]; then
		systemctl enable tracker || true
	fi
	if [[ $install_file = 1 ]]; then
		systemctl enable filebrowser || true
	fi
	if [[ $install_aria = 1 ]]; then
		systemctl enable aria2 || true
	fi
	if [[ $install_v2ray = 1 ]] || [[ $install_ss = 1 ]]; then
		systemctl enable v2ray || true
	fi
	if [[ $install_trojan = 1 ]]; then
		systemctl enable trojan || true
	fi
	systemctl enable nginx || true
}
############Set UP V2ray############
installv2ray(){
	bash <(curl -L -s https://install.direct/go.sh) > /dev/null
	rm -rf /etc/v2ray/config.json
	uuid=$(/usr/bin/v2ray/v2ctl uuid)
	if [[ $install_v2ray = 1 ]] && [[ $install_ss = 1 ]]; then
	cat > "/etc/v2ray/config.json" << EOF
{
	"log": {
		"loglevel": "warning",
		"access": "/var/log/v2ray/access.log",
		"error": "/var/log/v2ray/error.log"
	},
	"inbounds": [
				{
						"sniffing": {
						"enabled": true,
						"destOverride": ["http","tls"]
				},
				"port": 10000,
				"listen":"127.0.0.1",
				"protocol": "vmess",
				"settings": {
						"clients": [
								{
										"id": "$uuid",
										"alterId": $alterid
								}
						]
				},
				"streamSettings": {
						"network": "ws",
						"wsSettings": {
				"path": "$path"
				}
				}
		},
		{
		"port": "20000",
		"listen": "127.0.0.1",
		"protocol": "dokodemo-door",
		"tag": "ssin",
		"settings": {
			"address": "v1.mux.cool",
			"followRedirect": false,
			"network": "tcp"
		},
		"streamSettings": {
			"network": "ws",
			"wsSettings": {
			"path": "$sspath"
			}
		}
	},
	{
		"port": 9015,
		"listen": "127.0.0.1",
		"protocol": "shadowsocks",
		"settings": {
			"method": "$ssmethod",
			"ota": false,
			"password": "$sspasswd",
			"network": "tcp,udp"
		},
		"streamSettings": {
			"network": "domainsocket"
		}
	}
	],
	"outbounds": [
		{
			"protocol": "freedom",
			"settings": {}
		},
		{
			"protocol": "blackhole",
			"settings": {},
			"tag": "blocked"
		},
		{
			"protocol": "freedom",
			"tag": "ssmux",
			"streamSettings": {
				"network": "domainsocket"
			}
		}
	],
	"transport": {
		"dsSettings": {
			"path": "/var/run/ss-loop.sock"
		}
	},
	"routing": {
		"domainStrategy": "IPIfNonMatch",
		"rules": [
			{
				"type": "field",
				"inboundTag": ["ssin"],
				"outboundTag": "ssmux"
			},
			{
				"type": "field",
				"domain": [
				"domain:baidu.com",
				"domain:qq.com",
				"domain:sina.com",
				"geosite:qihoo360"
			],
			"outboundTag": "blocked"
			}
		]
	}
}
EOF
elif [[ $install_ss = 1 ]]; then
	cat > "/etc/v2ray/config.json" << EOF
{
	"log": {
		"loglevel": "warning",
		"access": "/var/log/v2ray/access.log",
		"error": "/var/log/v2ray/error.log"
	},
	"inbounds": [
		{
		"port": "20000",
		"listen": "127.0.0.1",
		"protocol": "dokodemo-door",
		"tag": "ssin",
		"settings": {
			"address": "v1.mux.cool",
			"followRedirect": false,
			"network": "tcp"
		},
		"streamSettings": {
			"network": "ws",
			"wsSettings": {
			"path": "$sspath"
			}
		}
	},
	{
		"port": 9015,
		"listen": "127.0.0.1",
		"protocol": "shadowsocks",
		"settings": {
			"method": "$ssmethod",
			"ota": false,
			"password": "$sspasswd",
			"network": "tcp,udp"
		},
		"streamSettings": {
			"network": "domainsocket"
		}
	}
	],
	"outbounds": [
		{
			"protocol": "freedom",
			"settings": {}
		},
		{
			"protocol": "blackhole",
			"settings": {},
			"tag": "blocked"
		},
		{
			"protocol": "freedom",
			"tag": "ssmux",
			"streamSettings": {
				"network": "domainsocket"
			}
		}
	],
	"transport": {
		"dsSettings": {
			"path": "/var/run/ss-loop.sock"
		}
	},
	"routing": {
		"domainStrategy": "IPIfNonMatch",
		"rules": [
			{
				"type": "field",
				"inboundTag": ["ssin"],
				"outboundTag": "ssmux"
			},
			{
				"type": "field",
				"domain": [
				"domain:baidu.com",
				"domain:qq.com",
				"domain:sina.com",
				"geosite:qihoo360"
			],
			"outboundTag": "blocked"
			}
		]
	}
}
EOF
	else
			cat > "/etc/v2ray/config.json" << EOF
{
	"log": {
		"loglevel": "warning",
		"access": "/var/log/v2ray/access.log",
		"error": "/var/log/v2ray/error.log"
	},
	"inbounds": [
				{
						"sniffing": {
						"enabled": true,
						"destOverride": ["http","tls"]
				},
				"port": 10000,
				"listen":"127.0.0.1",
				"protocol": "vmess",
				"settings": {
						"clients": [
								{
										"id": "$uuid",
										"alterId": $alterid
								}
						]
				},
				"streamSettings": {
						"network": "ws",
						"wsSettings": {
				"path": "$path"
				}
				}
		}
	],
	"outbounds": [
		{
			"protocol": "freedom",
			"settings": {}
		},
		{
			"protocol": "blackhole",
			"settings": {},
			"tag": "blocked"
		}
	],
	"routing": {
		"domainStrategy": "IPIfNonMatch",
		"rules": [
			{
				"type": "field",
				"domain": [
				"domain:baidu.com",
				"domain:qq.com",
				"domain:sina.com",
				"geosite:qihoo360"
			],
			"outboundTag": "blocked"
			}
		]
	}
}
EOF
	fi
}
##########V2ray Client Config################
v2rayclient(){
	if [[ $install_v2ray = 1 ]]; then
	touch /etc/v2ray/client.json
	cat > '/etc/v2ray/client.json' << EOF
{
	"inbounds": [
		{
			"listen": "127.0.0.1",
			"port": 1081,
			"protocol": "socks",
			"settings":{},
			"sniffing": {
				"enabled": true,
				"destOverride": ["http","tls"]
				}
			},
		{
			"listen": "127.0.0.1",
			"port": 8001,
			"protocol": "http",
			"settings": {},
			"sniffing": {
				"enabled": true,
				"destOverride": ["http","tls"]
			}
		}
	],
	"outbounds": [
		{
			"tag": "proxy",
			"protocol": "vmess",
			"settings": {
				"vnext": [
					{
						"address": "$domain",
						"port": 443,
						"users": [
							{
								"id": "$uuid",
								"alterId": $alterid,
								"security": "auto"
							}
						]
					}
				]
			},
			"streamSettings": {
			"network": "ws",
			"security": "tls",
			"wsSettings": {
				"path": "$path",
				"headers": {
					"Host": "$domain"
				}
			},
			"tlsSetting": {
				"allowInsecure": false,
				"alpn": ["http/1.1","h2"],
				"serverName": "$domain",
				"allowInsecureCiphers": false,
				"disableSystemRoot": false
			},
				"sockopt": {
					"mark": 255
				}
			},
			"mux": {
				"enabled": false
			}
		},
		{
			"tag": "direct",
			"protocol": "freedom",
			"settings": {},
			"streamSettings": {
				"sockopt": {
					"mark": 255
				}
			}
		},
		{
			"tag": "adblock",
			"protocol" : "blackhole",
			"settings": {},
			"streamSettings": {
				"sockopt": {
					"mark": 255
				}
			}
		},
		{
			"protocol": "dns",
			"tag": "dns-out"
		}
	],
		"dns": {
			"hosts": {
		"geosite:qihoo360": "0.0.0.0"
		},
		"servers": [
			"8.8.4.4",
			"1.1.1.1",
			{
				"address": "114.114.114.114",
				"port": 53,
				"domains": ["geosite:cn","ntp.org"]
			}
		]
	},
	"routing": {
		"domainStrategy": "IPIfNonMatch",
		"rules": [
			{
				"type": "field",
				"inboundTag": ["dns-in"],
				"outboundTag": "dns-out"
			},
			{                                                                   
				"type": "field",                                                  
				"domain": ["geosite:qihoo360"],                                   
				"outboundTag": "adblock"                                          
			},
			{
				"type": "field",
				"outboundTag": "direct",
				"ip": ["geoip:private"]
			},
			{
				"type": "field",
				"outboundTag": "direct",
				"ip": ["geoip:cn"]
			},
			{
				"type": "field",
				"outboundTag": "direct",
				"domain": ["geosite:cn"]
			},
			{
				"type": "field",
				"outboundTag": "direct",
				"protocol": ["bittorrent"]
			}
		]
	}
}
EOF
	fi
}
##########Check for update############
checkupdate(){
	cd
	apt-get update
	apt-get upgrade -y
	if [[ -f /usr/bin/v2ray/v2ray ]]; then
		wget https://install.direct/go.sh -q
		bash go.sh
		rm go.sh
	fi
	if [[ -f /usr/local/bin/trojan ]]; then
		bash -c "$(curl -fsSL https://raw.githubusercontent.com/trojan-gfw/trojan-quickstart/master/trojan-quickstart.sh)"
	fi
}
###########Trojan share link########
sharelink(){
	cd
	clear
	echo "安装成功，享受吧！(Install Success! Enjoy it ! )多行不義必自斃，子姑待之。" > result
	echo "请按方向键往下拉(Please press Arrow keys to scroll down)" >> result
	if [[ $install_trojan = 1 ]]; then
		colorEcho ${INFO} "你的(Your) Trojan-Gfw 客户端(client) config profile 1"
		cat /etc/trojan/client1.json
		colorEcho ${INFO} "你的(Your) Trojan-Gfw 客户端(client) config profile 2"
		cat /etc/trojan/client2.json
		echo "你的(Your) Trojan-Gfw 客户端(client) config profile 1" >> result
		echo "$(cat /etc/trojan/client1.json)" >> result
		echo "你的(Your) Trojan-Gfw 客户端(client) config profile 2" >> result
		echo "$(cat /etc/trojan/client2.json)" >> result
		cd
		echo "你的 Trojan-Gfw 分享链接(Share Link)1 is" >> result
		echo "trojan://$password1@$domain:443" >> result
		echo "你的 Trojan-Gfw 分享链接(Share Link)2 is" >> result
		echo "trojan://$password2@$domain:443" >> result
		if [[ $dist = centos ]]; then
		colorEcho ${ERROR} "QR generate Fail ! Because your os does not support python3-qrcode,Please consider change your os!"
		elif [[ $(lsb_release -cs) = xenial ]] || [[ $(lsb_release -cs) = trusty ]] || [[ $(lsb_release -cs) = jessie ]]
		then
		colorEcho ${ERROR} "QR generate Fail ! Because your os does not support python3-qrcode,Please consider change your os!"
		else
		apt-get install python3-qrcode -qq -y > /dev/null
		wget https://github.com/trojan-gfw/trojan-url/raw/master/trojan-url.py -q
		chmod +x trojan-url.py
		#./trojan-url.py -i /etc/trojan/client.json
		./trojan-url.py -q -i /etc/trojan/client1.json -o $password1.png || true
		./trojan-url.py -q -i /etc/trojan/client2.json -o $password2.png || true
		cp $password1.png /usr/share/nginx/html/ || true
		cp $password2.png /usr/share/nginx/html/ || true
		echo "请访问下面的链接获取Trojan-GFW 二维码(QR code) 1" >> result
		echo "https://$domain/$password1.png" >> result
		echo "请访问下面的链接获取Trojan-GFW 二维码(QR code) 2" >> result
		echo "https://$domain/$password2.png" >> result
		rm -rf trojan-url.py
		rm -rf $password1.png || true
		rm -rf $password2.png || true
		apt-get remove python3-qrcode -qq -y > /dev/null
	fi
		echo "相关链接（Related Links）" >> result
		echo "https://github.com/trojan-gfw/trojan/wiki/Mobile-Platforms" >> result
		echo "https://github.com/trojan-gfw/trojan/releases/latest" >> result
	fi
	if [[ $install_qbt = 1 ]]; then
		echo
		echo "" >> result
		echo "你的Qbittorrent信息(Your Qbittorrent Information)" >> result
		echo "https://$domain$qbtpath 用户名(username): admin 密碼(password): adminadmin" >> result
		echo "请手动将Qbittorrent下载目录改为 /usr/share/nginx/qbt/ ！！！否则拉回本地将不起作用！！！" >> result
		echo "请手动将Qbittorrent中的Bittorrent加密選項改为 強制加密 ！！！否则會被迅雷吸血！！！" >> result
		echo "请手动在Qbittorrent中添加Trackers https://github.com/ngosang/trackerslist ！！！否则速度不會快的！！！" >> result
	fi
	if [[ $install_tracker = 1 ]]; then
		echo
		echo "" >> result
		echo "你的Bittorrent-Tracker信息(Your Bittorrent-Tracker Information)" >> result
		echo "https://$domain:443$trackerpath" >> result
		echo "http://$domain:8000/announce" >> result
		echo "你的Bittorrent-Tracker信息（查看状态用）(Your Bittorrent-Tracker Status Information)" >> result
		echo "https://$domain:443$trackerstatuspath" >> result
		echo "请手动将此Tracker添加于你的BT客户端中，发布种子时记得填上即可。" >> result
		echo "请记得将此Tracker分享给你的朋友们。" >> result
	fi
	if [[ $install_aria = 1 ]]; then
		echo
		echo "" >> result
		echo "你的Aria信息，非分享链接，仅供参考(Your Aria2 Information)" >> result
		echo "$ariapasswd@https://$domain:443$ariapath" >> result
	fi
	if [[ $install_file = 1 ]]; then
		echo
		colorEcho ${INFO} "你的Filebrowser信息，非分享链接，仅供参考(Your Filebrowser Information)"
		colorEcho ${LINK} "https://$domain:443$filepath 用户名(username): admin 密碼(password): admin"
		echo "" >> result
		echo "你的Filebrowser信息，非分享链接，仅供参考(Your Filebrowser Information)" >> result
		echo "https://$domain:443$filepath 用户名(username): admin 密碼(password): admin" >> result
	fi
	if [[ $install_netdata = 1 ]]; then
		echo
		colorEcho ${INFO} "你的netdata信息，非分享链接，仅供参考(Your Netdata Information)"
		colorEcho ${LINK} "https://$domain:443$netdatapath"
		echo "" >> result
		echo "你的netdata信息，非分享链接，仅供参考(Your Netdata Information)" >> result
		echo "https://$domain:443$netdatapath" >> result
	fi
	if [[ $install_v2ray = 1 ]]; then
	echo
	$pack install qrencode > /dev/null || true
	v2rayclient
	colorEcho ${INFO} "你的(Your) V2ray 客户端(client) config profile"
	echo "你的(Your) V2ray 客户端(client) config profile" >> result
	echo "$(cat /etc/v2ray/client.json)" >> result
	cat /etc/v2ray/client.json
	echo
	wget https://github.com/boypt/vmess2json/raw/master/json2vmess.py -q
	chmod +x json2vmess.py
	touch /etc/v2ray/$uuid.txt
	v2link=$(./json2vmess.py --addr $domain --filter ws --amend net:ws --amend port:443 --amend id:$uuid --amend aid:$alterid --amend tls:tls --amend host:$domain --amend path:$path /etc/v2ray/config.json) || true
		cat > "/etc/v2ray/$uuid.txt" << EOF
$v2link
EOF
	cp /etc/v2ray/$uuid.txt /usr/share/nginx/html/
	qrencode -l L -v 1 -o /usr/share/nginx/html/$uuid.png "$v2link"
	colorEcho ${INFO} "你的V2ray分享链接(Your V2ray Share Link)"
	cat /etc/v2ray/$uuid.txt
	colorEcho ${INFO} "你的V2ray二维码(Your V2ray Share Link)"
	colorEcho ${INFO} "https://$domain/$uuid.png"
	echo "" >> result
	echo "你的V2ray分享链接(Your V2ray Share Link)" >> result
	echo "$(cat /etc/v2ray/$uuid.txt)" >> result
	echo "请访问下面的链接(Link Below)获取你的V2ray分享链接" >> result
	echo "https://$domain/$uuid.txt" >> result
	echo "请访问下面的链接(Link Below)获取你的V2ray二维码" >> result
	echo "https://$domain/$uuid.png" >> result
	rm -rf json2vmess.py
	echo "Please manually run cat /etc/v2ray/$uuid.txt to show share link again!" >> result
	echo "相关链接（Related Links）" >> result
	echo "https://play.google.com/store/apps/details?id=fun.kitsunebi.kitsunebi4android" >> result
	echo "https://github.com/v2ray/v2ray-core/releases/latest" >> result
	$pack remove qrencode > /dev/null || true
	fi
	if [[ $install_ss = 1 ]]; then
		echo
		$pack install qrencode > /dev/null || true
		sspath2="$(echo "$sspath" | cut -c2-999)"
		ssinfo="$(echo $ssmethod:$sspasswd@$domain:443 | base64)"
		sslink1="ss://$ssinfo?plugin=v2ray%3Bpath%3D%2F$sspath2%3Bhost%3D$domain%3Btls#ss+v2ray-plugin"
		sslink2="ss://$(echo $ssmethod:$sspasswd | base64)@$domain:443#$domain"
		qrencode -l L -v 1 -o /usr/share/nginx/html/qr1-$sspasswd.png "$sslink1"
		qrencode -l L -v 1 -o /usr/share/nginx/html/qr2-$sspasswd.png "$sslink2"
		echo "" >> result
		echo "你的SS信息，非分享链接，仅供参考(Your Shadowsocks Information)" >> result
		echo "$ssmethod:$sspasswd@https://$domain:443$sspath" >> result
		echo "" >> result
		echo "你的SS分享链接，仅供参考(Your Shadowsocks Share link)" >> result
		echo "$sslink1" >> result
		echo "$sslink2" >> result
		echo "请访问下面的链接(Link Below)获取你的SS二维码" >> result
		echo "https://$domain/qr1-$sspasswd.png" >> result
		echo "https://$domain/qr2-$sspasswd.png" >> result
		echo "相关链接（Related Links）" >> result
		echo "https://play.google.com/store/apps/details?id=fun.kitsunebi.kitsunebi4android" >> result
		echo "https://play.google.com/store/apps/details?id=com.github.shadowsocks.plugin.v2ray" >> result
		echo "https://github.com/shadowsocks/v2ray-plugin" >> result
		$pack remove qrencode > /dev/null || true
	fi
	echo "请手动运行 cat result 来重新显示结果" >> result
}
##########Remove Trojan-Gfw##########
uninstall(){
	cd
	if [[ -f /usr/local/bin/trojan ]]; then
		if (whiptail --title "api" --yesno "卸载 (uninstall) trojan?" 8 78); then
		systemctl stop trojan || true
		systemctl disable trojan || true
		rm -rf /etc/systemd/system/trojan* || true
		rm -rf /usr/local/etc/trojan/* || true
		fi
	fi
	if [[ -f /usr/sbin/nginx ]]; then
		if (whiptail --title "api" --yesno "卸载 (uninstall) nginx?" 8 78); then
		systemctl stop nginx || true
		systemctl disable nginx || true
		$pack remove nginx
		rm -rf /etc/apt/sources.list.d/nginx.list || true
		fi
	fi
	if [[ -f /usr/sbin/dnsmasq ]]; then
		if (whiptail --title "api" --yesno "卸载 (uninstall) dnsmasq?" 8 78); then
			if [[ $dist = centos ]]; then
			yum remove dnsmasq -y -q || true
			else
			apt purge dnsmasq -p -y || true
			fi
		fi
	fi
	if [[ -f /usr/bin/qbittorrent-nox ]]; then
		if (whiptail --title "api" --yesno "卸载 (uninstall) qbittorrent?" 8 78); then
		systemctl stop qbittorrent || true
		systemctl disable qbittorrent || true
		$pack remove qbittorrent-nox
		fi
	fi
	if [[ -f /usr/bin/bittorrent-tracker ]]; then
		if (whiptail --title "api" --yesno "卸载 (uninstall) bittorrent-tracker?" 8 78); then
		systemctl stop tracker || true
		systemctl disable tracker || true
		rm -rf /usr/bin/bittorrent-tracker || true
		fi
	fi
	if [[ -f /usr/local/bin/aria2c ]]; then
		if (whiptail --title "api" --yesno "卸载 (uninstall) aria2?" 8 78); then
		systemctl stop aria || true
		systemctl disable aria || true
		rm -rf /etc/aria.conf || true
		rm -rf /usr/local/bin/aria2c || true
		fi
	fi
	if [[ -f /usr/local/bin/filebrowser ]]; then
		if (whiptail --title "api" --yesno "卸载 (uninstall) filebrowser?" 8 78); then
		systemctl stop filebrowser || true
		systemctl disable filebrowser || true
		rm /usr/local/bin/filebrowser
		fi
	fi
	if [[ -f /usr/sbin/netdata ]]; then
		if (whiptail --title "api" --yesno "卸载 (uninstall) netdata?" 8 78); then
		systemctl stop netdata || true
		systemctl disable netdata || true
		rm -rf /usr/sbin/netdata
		fi
	fi
	if [[ -f /usr/bin/v2ray/v2ray ]]; then
		if (whiptail --title "api" --yesno "卸载 (uninstall) v2ray/ss?" 8 78); then
		systemctl stop v2ray  || true
		systemctl disable v2ray || true
		wget https://install.direct/go.sh -q
		bash go.sh --remove
		rm go.sh
		fi
	fi
	if [[ -f /usr/bin/tor ]]; then
		if (whiptail --title "api" --yesno "卸载 (uninstall) tor?" 8 78); then
		systemctl stop tor  || true
		systemctl disable tor || true
		systemctl stop tor@default || true
		$pack remove tor
		rm -rf /etc/apt/sources.list.d/tor.list || true
		fi
	fi
	if (whiptail --title "api" --yesno "卸载 (uninstall) acme.sh?" 8 78); then
		~/.acme.sh/acme.sh --uninstall
	fi
	apt-get update
	systemctl daemon-reload || true
	colorEcho ${INFO} "卸载完成"
}
###########Status#################
statuscheck(){
	if [[ -f /usr/local/bin/trojan ]]; then
		trojanstatus=$(systemctl is-active trojan)
		if [[ $trojanstatus == active ]]; then
			echo ""
			colorEcho ${INFO} "Trojan-GFW状态：正常运行中(Normal)"
			else
				echo ""
			colorEcho ${INFO} "Trojan-GFW状态：服务状态异常(Not Running)" 
		fi
	fi
	if [[ -f /usr/sbin/nginx ]]; then
		nginxstatus=$(systemctl is-active nginx)
		if [[ $nginxstatus == active ]]; then
			echo ""
			colorEcho ${INFO} "Nginx状态：正常运行中(Normal)"
			else
				echo ""
			colorEcho ${INFO} "Nginx状态：服务状态异常(Not Running)" 
		fi
	fi
	if [[ -f /usr/sbin/dnsmasq ]]; then
		dnsmasqstatus=$(systemctl is-active dnsmasq)
		if [[ $dnsmasqstatus == active ]]; then
			echo ""
			colorEcho ${INFO} "Dnsmasq状态：正常运行中(Normal)"
			else
				echo ""
			colorEcho ${INFO} "Dnsmasq状态：服务状态异常(Not Running)" 
		fi
	fi
	if [[ -f /usr/bin/qbittorrent-nox ]]; then
		qbtstatus=$(systemctl is-active qbittorrent)
		if [[ $qbtstatus == active ]]; then
			echo ""
			colorEcho ${INFO} "Qbittorrent状态：正常运行中(Normal)"
			else
				echo ""
			colorEcho ${INFO} "Qbittorrent状态：服务状态异常(Not Running)" 
		fi
	fi
	if [[ -f /usr/bin/bittorrent-tracker ]]; then
		trackerstatus=$(systemctl is-active tracker)
		if [[ $trackerstatus == active ]]; then
			echo ""
			colorEcho ${INFO} "Bittorrent-Tracker状态：正常运行中(Normal)"
			else
				echo ""
			colorEcho ${INFO} "Bittorrent-Tracker状态：服务状态异常(Not Running)" 
		fi
	fi
	if [[ -f /usr/local/bin/aria2c ]]; then
		aria2status=$(systemctl is-active aria2)
		if [[ $nginxstatus == active ]]; then
			echo ""
			colorEcho ${INFO} "Aria2状态：正常运行中(Normal)"
			else
				echo ""
			colorEcho ${INFO} "Aria2状态：服务状态异常(Not Running)" 
		fi
	fi
	if [[ -f /usr/local/bin/filebrowser ]]; then
		filestatus=$(systemctl is-active filebrowser)
		if [[ $filestatus == active ]]; then
			echo ""
			colorEcho ${INFO} "Filebrowser状态：正常运行中(Normal)"
			else
				echo ""
			colorEcho ${INFO} "Filebrowser状态：服务状态异常(Not Running)" 
		fi
	fi
	if [[ -f /usr/sbin/netdata ]]; then
		netdatastatus=$(systemctl is-active netdata)
		if [[ $netdatastatus == active ]]; then
			echo ""
			colorEcho ${INFO} "Netdata状态：正常运行中(Normal)"
			else
				echo ""
			colorEcho ${INFO} "Netdata状态：服务状态异常(Not Running)" 
		fi
	fi
	if [[ -f /usr/bin/v2ray/v2ray ]]; then
		v2raystatus=$(systemctl is-active v2ray)
		if [[ $v2raystatus == active ]]; then
			echo ""
			colorEcho ${INFO} "V2ray(ss)状态：正常运行中(Normal)"
			else
			echo ""
			colorEcho ${INFO} "V2ray(ss)状态：服务状态异常(Not Running)" 
		fi
	fi
	if [[ -f /usr/bin/tor ]]; then
		torstatus=$(systemctl is-active tor)
		if [[ $torstatus == active ]]; then
			echo ""
			colorEcho ${INFO} "Tor状态：正常运行中(Normal)"
			else
			echo ""
			colorEcho ${INFO} "Tor状态：服务状态异常(Not Running)" 
		fi
	fi
	echo ""
	colorEcho ${INFO} "状态检查完成(Status Check complete)"
}
##################################
clear
function advancedMenu() {
		ADVSEL=$(whiptail --clear --ok-button "吾意已決 立即安排" --title "Trojan-Gfw Script Menu" --menu --nocancel "Choose an option RTFM: https://www.johnrosen1.com/trojan/
运行此脚本前请在控制面板中开启80 443端口并关闭Cloudflare CDN!" 13 78 4 \
				"1" "安裝(Install)" \
				"2" "状态查看(Status)" \
				"3" "更新(Update)" \
				"4" "卸載(Uninstall)" \
				"5" "退出(Quit)" 3>&1 1>&2 2>&3)
		case $ADVSEL in
				1)
				cd
				clear
				userinput
				installdependency
				openfirewall
				issuecert
				nginxtrojan || true
				bootstart
				start
				sharelink || true
				rm results || true
				whiptail --title "Install Success" --textbox --scrolltext result 32 120
				;;
				2)
				cd
				statuscheck
				;;
				3)
				cd
				checkupdate
				colorEcho ${SUCCESS} "RTFM: https://www.johnrosen1.com/trojan/"
				;;
				4)
				cd
				uninstall
				colorEcho ${SUCCESS} "Remove complete"
				;;
				5)
				exit
				whiptail --title "脚本已退出" --msgbox "脚本已退出(Bash Exited) RTFM: https://www.johnrosen1.com/trojan/" 8 78
				;;
		esac
}
cd
if grep -q "# zh_TW.UTF-8 UTF-8" /etc/locale.gen ; then
echo "zh_TW.UTF-8 UTF-8" > /etc/locale.gen
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
dpkg-reconfigure --frontend=noninteractive locales
echo 'LANG="zh_TW.UTF-8"'>/etc/default/locale 
fi
if grep -q "zh_TW.UTF-8 UTF-8" /etc/locale.gen; then
	:
	else
echo "zh_TW.UTF-8 UTF-8" > /etc/locale.gen
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
dpkg-reconfigure --frontend=noninteractive locales
echo 'LANG="zh_TW.UTF-8"'>/etc/default/locale  
fi
export LANG="zh_TW.UTF-8"
export LC_ALL="zh_TW.UTF-8"
osdist || true
clear
myip=$(curl -s https://api.ipify.org)
localip=$(ip a | grep inet | grep "scope global" | awk '{print $2}' | cut -d'/' -f1)
myipv6=$(ip -6 a | grep inet6 | grep "scope global" | awk '{print $2}' | cut -d'/' -f1)
advancedMenu
