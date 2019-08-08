#! /usr/bin/env nix-shell
#! nix-shell -i bash -p bridge-utils iptables

#
# Routed network configuration script
#

# bridge setup
brctl addbr br0
ifconfig br0 10.10.20.1/24 up

# enable ipv4 forwarding
echo "1" > /proc/sys/net/ipv4/ip_forward

# netfilter cleanup
iptables --flush
iptables -t nat -F
iptables -X
iptables -Z
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT

# netfilter network address translation
iptables -t nat -A POSTROUTING -o wlp2s0 -s 10.10.20.0/24  -j MASQUERADE
