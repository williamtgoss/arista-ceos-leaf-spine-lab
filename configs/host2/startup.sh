#!/bin/sh
# ============================================================
# host2 — VLAN 200, LACP bond to leaf2a (eth1) and leaf2b (eth2)
# Bond: bond0 (802.3ad/LACP), VLAN subinterface: bond0.200
# Static IP: 192.168.200.10/24   Gateway: 192.168.200.1
# ============================================================

# Install full iproute2 (replaces busybox ip for bonding support)
apk add --no-cache --quiet iproute2 iputils

# Load bonding kernel module
modprobe bonding 2>/dev/null || true

# Bring member interfaces down before bonding
ip link set eth1 down
ip link set eth2 down

# Create bond0 and configure 802.3ad (LACP) BEFORE adding members
ip link add bond0 type bond
ip link set bond0 type bond mode 802.3ad
ip link set bond0 type bond lacp_rate fast
ip link set bond0 type bond miimon 100
ip link set bond0 type bond xmit_hash_policy layer3+4

# Add eth1 and eth2 as bond members
ip link set eth1 master bond0
ip link set eth2 master bond0

# Bring up bond and members
ip link set bond0 up
ip link set eth1 up
ip link set eth2 up

# Create VLAN 200 tagged subinterface on the bond
ip link add link bond0 name bond0.200 type vlan id 200
ip link set bond0.200 up

# Assign static IP and default gateway
ip addr add 192.168.200.10/24 dev bond0.200
ip route add default via 192.168.200.1

echo "=== host2 network configuration complete ==="
ip addr show bond0.200
ip route show
