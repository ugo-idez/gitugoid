#!/bin/bash
bash wireguard.sh
cp endpoint-a.* wg0-a.conf /etc/wireguard
cd /etc/wireguard
mv wg0-a.conf wg0.conf
systemctl start wg-quick@wg0
systemctl enable wg-quick@wg0
