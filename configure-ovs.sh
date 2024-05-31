#!/bin/bash
set -eux

# Script to configure Open vSwitch (OVS) on a deployed machine
# Hosted on GitHub: https://github.com/hitmanpragalbh/maas-configurations

# Update package lists and install Open vSwitch
echo "Updating package lists..."
apt-get update

echo "Installing Open vSwitch..."
apt-get install -y openvswitch-switch

# Customize the following variables according to your requirements
# PXE boot interface (change if PXE interface is different)
PXE_INTERFACE="eno1"

# The network interfaces to be included in the OVS bridge (excluding PXE_INTERFACE)
INTERFACES=("eno2" "eno3" "eno4")

# The name of the OVS bridge
BRIDGE_NAME="br0"

# VLAN IDs for tenant, storage, and public networks (change as needed)
VLAN_TENANT="102"
VLAN_STORAGE="101"
VLAN_PUBLIC="103"

# Function to create and configure OVS bridge and VLANs
configure_ovs() {
  echo "Configuring OVS bridge and bond..."

  # Create OVS bridge
  ovs-vsctl add-br $BRIDGE_NAME

  # Add interfaces to OVS bridge
  for iface in "${INTERFACES[@]}"; do
    ovs-vsctl add-port $BRIDGE_NAME $iface
  done

  # Configure VLANs on the bridge
  ovs-vsctl add-br vlan$VLAN_TENANT $BRIDGE_NAME $BRIDGE_NAME.$VLAN_TENANT
  ovs-vsctl add-br vlan$VLAN_STORAGE $BRIDGE_NAME $BRIDGE_NAME.$VLAN_STORAGE
  ovs-vsctl add-br vlan$VLAN_PUBLIC $BRIDGE_NAME $BRIDGE_NAME.$VLAN_PUBLIC

  # Enable DHCP for IPv4 and IPv6 on the VLAN interfaces
  cat <<EOF > /etc/netplan/01-netcfg.yaml
network:
  version: 2
  ethernets:
    $PXE_INTERFACE:
      dhcp4: true
    $BRIDGE_NAME:
      dhcp4: false
  bridges:
    vlan$VLAN_TENANT:
      interfaces: [$BRIDGE_NAME.$VLAN_TENANT]
      dhcp4: true
      dhcp6: true
    vlan$VLAN_STORAGE:
      interfaces: [$BRIDGE_NAME.$VLAN_STORAGE]
      dhcp4: true
      dhcp6: true
    vlan$VLAN_PUBLIC:
      interfaces: [$BRIDGE_NAME.$VLAN_PUBLIC]
      dhcp4: true
      dhcp6: true
EOF

  echo "Applying netplan configuration..."
  netplan apply
}

# Call the function to configure OVS
configure_ovs

echo "OVS configuration completed successfully."

# End of script
