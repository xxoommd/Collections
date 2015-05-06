#! /bin/sh

runner=`whoami`
if [ "$runner" != "root" ] ; then
	echo "Please run this script by root."
else
	echo "Start Running..."
	# Install pptpd iptables
	apt-get update
	apt-get install -y pptpd iptables

	# Config /etc/pptpd.conf
	echo "option /etc/ppp/pptpd-options\nlogwtmp\nlocalip 10.20.0.1\nremoteip 10.20.0.2-238,10.20.0.10" > /etc/pptpd.conf

	# Config /etc/ppp/chap-secrets
	echo "# 用户名 类型 密码 连接IP" > /etc/ppp/chap-secrets
	echo "gaofei pptpd really001 *" >> /etc/ppp/chap-secrets

	# Config /etc/ppp/pptpd-options
	echo "name pptpd\nrefuse-pap\nrefuse-chap\nrefuse-mschap\nrequire-mschap-v2\nrequire-mppe-128\nms-dns 8.8.8.8\nms-dns 8.8.4.4\nproxyarp\nnodefaultroute\nlock\nnobsdcomp\nnovj\nnovjccomp\nnologfd" > /etc/ppp/pptpd-options

	# Config /etc/sysctl.conf
	echo "net.ipv4.ip_forward=1" > /etc/sysctl.conf

	# Excutions
	sysctl -p
	iptables -t nat -A POSTROUTING -s 10.20.0.0/24 -o eth0 -j MASQUERADE
	service pptpd restart
fi
