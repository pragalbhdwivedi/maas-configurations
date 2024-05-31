#!/bin/bash
set -eux

# Install Open vSwitch
apt-get update
apt-get install -y openvswitch-switch

# Create OVS bridge and bond
ovs-vsctl add-br br0
ovs-vsctl add-bond br0 bond0 eno1 eno2 eno3 -- set port bond0 bond_mode=balance-tcp
