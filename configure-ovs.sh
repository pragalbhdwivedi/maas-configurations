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

  # Download the netplan configuration file from GitHub
  echo "Downloading netplan configuration from GitHub..."
  curl -L https://raw.githubusercontent.com/hitmanpragalbh/maas-configurations/main/netplan-config.yaml -o /etc/netplan/01-netcfg.yaml

  # Apply the netplan configuration
  echo "Applying netplan configuration..."
  netplan apply
}

# Call the function to configure OVS
configure_ovs

echo "OVS configuration completed successfully."

# End of script
