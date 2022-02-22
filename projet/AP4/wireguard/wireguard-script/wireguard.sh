#!/bin/bash
set -u
set -e

AddressAwg=10.0.0.1/32  # Adresse VPN Wireguard extremite A
EndpointA=10.121.38.66 # Adresse extremite A
PortA=51820             # Port ecoute extremite A
AddressBwg=10.0.0.2/32  # Adresse VPN Wireguard extremite B
EndpointB=192.168.2.14  # Adresse extremite B
PortB=51820             # Port ecoute extremite B
AddressCwg=10.0.0.3/32  # Adresse VPN Wireguard extremite C
EndpointC=192.168.2.15  # Adresse extremite C
PortC=51820             # Port ecoute extremite C

umask 077 ;
wg genkey > endpoint-a.key
wg pubkey < endpoint-a.key > endpoint-a.pub

wg genkey > endpoint-b.key
wg pubkey < endpoint-b.key > endpoint-b.pub

wg genkey > endpoint-c.key
wg pubkey < endpoint-c.key > endpoint-c.pub

PKA=$(cat endpoint-a.key)
pKA=$(cat endpoint-a.pub)
PKB=$(cat endpoint-b.key)
pKB=$(cat endpoint-b.pub)
PKC=$(cat endpoint-c.key)
pKC=$(cat endpoint-c.pub)

cat <<FINI > wg0-a.conf
# local settings for Endpoint A
[Interface]
PrivateKey = $PKA       #Clé privée du serveur vpn
Address = $AddressAwg   #Adresse du serveur vpn
ListenPort = $PortA

# remote settings for Endpoint B
[Peer]
PublicKey = $pKB        #Clé publique du client
AllowedIPs = $AddressBwg #Adresse vpn du client

# remote settings for Endpoint C
[Peer]
PublicKey = $pKC        #Clé publique du client
AllowedIPs = $AddressCwg #Adresse vpn du client
FINI


cat <<FINI > wg0-b.conf
# local settings for Endpoint B
[Interface]
PrivateKey = $PKB       #Clé privée du client
Address = $AddressBwg   #Adresse du client
ListenPort = $PortB

# remote settings for Endpoint A
[Peer]
PublicKey = $pKA       #Clé publique du serveur vpn
Endpoint = ${EndpointA}:$PortA #Adresse en dhcp (pont) du serveur vpn avec le port qu'on utilise
AllowedIPs = $AddressAwg #Adresse du serveur vpn
FINI


cat <<FINI > wg0-c.conf
# local settings for Endpoint C
[Interface]
PrivateKey = $PKC       #Clé privée du client
Address = $AddressCwg   #Adresse du client
ListenPort = $PortC

# remote settings for Endpoint A
[Peer]
PublicKey = $pKA       #Clé publique du serveur vpn
Endpoint = ${EndpointA}:$PortA #Adresse en dhcp (pont) du serveur vpn avec le port qu'on utilise
AllowedIPs = $AddressAwg #Adresse du serveur vpn
FINI
