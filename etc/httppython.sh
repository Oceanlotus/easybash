#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#=================================================
#       System Required: All
#       Description: Python HTTP Server
#       Version: 1.0.2
#       Author: Toyo
#       Blog: https://doub.io/wlzy-8/
#=================================================

sethttp(){
#���ö˿�
	while true
	do
	echo -e "������Ҫ���ŵ�HTTP����˿� [1-65535]"
	read -e -p "(Ĭ�϶˿�: 8000):" httpport
	[[ -z "$httpport" ]] && httpport="8000"
	expr ${httpport} + 0 &>/dev/null
	if [[ $? -eq 0 ]]; then
		if [[ ${httpport} -ge 1 ]] && [[ ${httpport} -le 65535 ]]; then
			echo
			echo -e "	�˿� : \033[41;37m ${httpport} \033[0m"
			echo
			break
		else
			echo "�������, ��������ȷ�Ķ˿ڡ�"
		fi
	else
		echo "�������, ��������ȷ�Ķ˿ڡ�"
	fi
	done
	#����Ŀ¼
	echo "������Ҫ���ŵ�Ŀ¼(����·��)"
	read -e -p "(ֱ�ӻس�, Ĭ�ϵ�ǰ�ļ���):" httpfile
	if [[ ! -z $httpfile ]]; then
		[[ ! -e $httpfile ]] && echo -e "\033[41;37m [����] \033[0m �����Ŀ¼������ �� ��ǰ�û���Ȩ�޷���, ����!" && exit 1
	else
		httpfile=`echo $PWD`
	fi
	#���ȷ��
	echo
	echo "========================"
	echo "      ���������Ƿ���ȷ !"
	echo
	echo -e "	�˿� : \033[41;37m ${httpport} \033[0m"
	echo -e "	Ŀ¼ : \033[41;37m ${httpfile} \033[0m"
	echo "========================"
	echo
	read -e -p "����������������д�����ʹ�� Ctrl + C �˳�." var
}
iptables_add(){
	iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport ${httpport} -j ACCEPT
	iptables -I INPUT -m state --state NEW -m udp -p udp --dport ${httpport} -j ACCEPT
}
iptables_del(){
	iptables -D INPUT -m state --state NEW -m tcp -p tcp --dport ${port} -j ACCEPT
	iptables -D INPUT -m state --state NEW -m udp -p udp --dport ${port} -j ACCEPT
}
starthttp(){
	PID=`ps -ef | grep SimpleHTTPServer | grep -v grep | awk '{print $2}'`
	[[ ! -z $PID ]] && echo -e "\033[41;37m [����] \033[0m SimpleHTTPServer �������У����� !" && exit 1
	sethttp
	iptables_add
	cd ${httpfile}
	nohup python -m SimpleHTTPServer $httpport >> httpserver.log 2>&1 &
	sleep 2s
	PID=`ps -ef | grep SimpleHTTPServer | grep -v grep | awk '{print $2}'`
	if [[ -z $PID ]]; then
		echo -e "\033[41;37m [����] \033[0m SimpleHTTPServer ����ʧ�� !" && exit 1
	else
		ip=`curl -m 10 -s http://members.3322.org/dyndns/getip`
		[[ -z "$ip" ]] && ip="VPS_IP"
		echo
		echo "HTTP���� ������ !"
		echo -e "��������ʣ���ַ�� \033[41;37m http://${ip}:${httpport} \033[0m "
		echo
	fi
}
stophttp(){
	PID=`ps -ef | grep SimpleHTTPServer | grep -v grep | awk '{print $2}'`
	[[ -z $PID ]] && echo -e "\033[41;37m [����] \033[0m û�з��� SimpleHTTPServer �������У����� !" && exit 1
	port=`netstat -lntp | grep ${PID} | awk '{print $4}' | awk -F ":" '{print $2}'`
	iptables_del
	kill -9 ${PID}
	sleep 2s
	PID=`ps -ef | grep SimpleHTTPServer | grep -v grep | awk '{print $2}'`
	if [[ ! -z $PID ]]; then
		echo -e "\033[41;37m [����] \033[0m SimpleHTTPServer ֹͣʧ�� !" && exit 1
	else
		echo
		echo "HTTP���� ��ֹͣ !"
		echo
	fi
}

action=$1
[[ -z $1 ]] && action=start
case "$action" in
    start|stop)
    ${action}http
    ;;
    *)
    echo "������� !"
    echo "�÷�: {start|stop}"
    ;;
esac