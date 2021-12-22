#!/bin/bash
IFEXT=ens33
echo "1" > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -o "${IFEXT}" -j MASQUERADE
exit 0
