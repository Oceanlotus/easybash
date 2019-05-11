#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#=================================================
#	System Required: CentOS/Debian/Ubuntu
#	Description: Libsodium Install
#	Version: 1.0.0
#	Author: Toyo
#	Blog: https://doub.io/shell-jc6/
#=================================================

Libsodiumr_file="/usr/local/lib/libsodium.so"
Libsodiumr_ver_backup="1.0.15"

Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[��Ϣ]${Font_color_suffix}" && Error="${Red_font_prefix}[����]${Font_color_suffix}" && Tip="${Green_font_prefix}[ע��]${Font_color_suffix}"

Check_Libsodium_ver(){
	echo -e "${Info} ��ʼ��ȡ libsodium ���°汾..."
	Libsodiumr_ver=$(wget -qO- "https://github.com/jedisct1/libsodium/tags"|grep "/jedisct1/libsodium/releases/tag/"|head -1|sed -r 's/.*tag\/(.+)\">.*/\1/')
	[[ -z ${Libsodiumr_ver} ]] && Libsodiumr_ver=${Libsodiumr_ver_backup}
	echo -e "${Info} libsodium ���°汾Ϊ ${Green_font_prefix}[${Libsodiumr_ver}]${Font_color_suffix} !"
}
Install_Libsodium(){
	if [[ -e ${Libsodiumr_file} ]]; then
		echo -e "${Error} libsodium �Ѱ�װ , �Ƿ񸲸ǰ�װ(���߸���)��[y/N]"
		read -e -p "(Ĭ��: n):" yn
		[[ -z ${yn} ]] && yn="n"
		if [[ ${yn} == [Nn] ]]; then
			echo "��ȡ��..." && exit 1
		fi
	else
		echo -e "${Info} libsodium δ��װ����ʼ��װ..."
	fi
	Check_Libsodium_ver
	if [[ ${release} == "centos" ]]; then
		yum update
		echo -e "${Info} ��װ����..."
		yum -y groupinstall "Development Tools"
		echo -e "${Info} ����..."
		wget  --no-check-certificate -N "https://github.com/jedisct1/libsodium/releases/download/${Libsodiumr_ver}/libsodium-${Libsodiumr_ver}.tar.gz"
		echo -e "${Info} ��ѹ..."
		tar -xzf libsodium-${Libsodiumr_ver}.tar.gz
		cd libsodium-${Libsodiumr_ver}
		echo -e "${Info} ���밲װ..."
		./configure --disable-maintainer-mode
		make -j2
		make install
		echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf
	else
		apt-get update
		echo -e "${Info} ��װ����..."
		apt-get install -y build-essential
		echo -e "${Info} ����..."
		wget  --no-check-certificate -N "https://github.com/jedisct1/libsodium/releases/download/${Libsodiumr_ver}/libsodium-${Libsodiumr_ver}.tar.gz"
		echo -e "${Info} ��ѹ..."
		tar -xzf libsodium-${Libsodiumr_ver}.tar.gz
		cd libsodium-${Libsodiumr_ver}
		echo -e "${Info} ���밲װ..."
		./configure --disable-maintainer-mode
		make -j2
		make install
	fi
	ldconfig
	cd ..
	rm -rf libsodium-${Libsodiumr_ver}.tar.gz
	rm -rf libsodium-${Libsodiumr_ver}
	[[ ! -e ${Libsodiumr_file} ]] && echo -e "${Error} libsodium ��װʧ�� !" && exit 1
	echo && echo -e "${Info} libsodium ��װ�ɹ� !" && echo
}
action=$1
[[ -z $1 ]] && action=install
case "$action" in
	install)
	Install_Libsodium
	;;
    *)
    echo "������� !"
    echo "�÷�: [ install ]"
    ;;
esac