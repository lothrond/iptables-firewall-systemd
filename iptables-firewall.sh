#!/bin/bash
#
# iptables firewall rules
#  install to: /usr/sbin
#

# Limit PATH
PATH="/sbin:/usr/sbin:/bin:/usr/bin"

firewall_start() {
	# Create ipv4 chains
	iptables -P INPUT DROP
	iptables -P FORWARD DROP
	iptables -P OUTPUT ACCEPT

	# Create ipv4 rules
	iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
	iptables -A INPUT -i lo -j ACCEPT
	iptables -A INPUT -p icmp --icmp-type 3 -j ACCEPT
	iptables -A INPUT -p icmp --icmp-type 11 -j ACCEPT
	iptables -A INPUT -p icmp --icmp-type 12 -j ACCEPT
	iptables -A INPUT -p tcp --syn --dport 113 -j REJECT --reject-with tcp-reset

	# sshd
	#iptables -A INPUT -p tcp --dport 22 -j ACCEPT

	# Fold@Home
	#iptables -A INPUT -p tcp --dport 36330 -j ACCEPT


	# devserver (Chromium OS)
	#iptables -A INPUT -p tcp --dport 8080 -j ACCEPT


	# Create ipv6 chains
	ip6tables -P INPUT DROP
	ip6tables -P FORWARD DROP
	ip6tables -P OUTPUT ACCEPT

	# Create ipv6 rules
	ip6tables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
	ip6tables -A INPUT -i lo -j ACCEPT
	ip6tables -A INPUT -m conntrack --ctstate INVALID -j DROP
	ip6tables -A INPUT -s fe80::/10 -p ipv6-icmp -j ACCEPT
	ip6tables -A INPUT -p udp -m conntrack --ctstate NEW -j REJECT --reject-with icmp6-port-unreachable
	ip6tables -A INPUT -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -m conntrack --ctstate NEW -j REJECT --reject-with tcp-reset

}

firewall_stop() {
	# Flush ipv4
	iptables -F
	iptables -X
	iptables -Z

	# Flush ipv6
	ip6tables -F
	ip6tables -X
	ip6tables -Z
}

# execute action
case "$1" in
  start|restart)
    echo "Starting firewall"
    firewall_stop
    firewall_start
    ;;
  stop)
    echo "Stopping firewall"
    firewall_stop
    ;;
esac
