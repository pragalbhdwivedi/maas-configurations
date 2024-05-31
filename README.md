# MAAS Configurations

## Description

Welcome to the `maas-configurations` repository! This repository contains a collection of cloud-init scripts and configuration files designed to automate and streamline the deployment and management of machines using MAAS (Metal as a Service).

### Purpose

The primary goal of this repository is to provide a centralized and version-controlled collection of scripts that facilitate the setup, configuration, and management of various network and storage settings during the MAAS deployment process. By using these scripts, you can ensure consistent and automated configuration across all machines in your infrastructure.

### Features

- **Automated Network Configuration:** Scripts to configure network interfaces, including bonding, bridging, and Open vSwitch (OVS) setup.
- **Storage Setup:** Automate the partitioning, formatting, and mounting of storage devices.
- **Custom Preseed Files:** Preseed configurations to install and configure software packages during deployment.
- **High Availability and Redundancy:** Configurations to set up bonded interfaces for improved redundancy and performance.

### Contents

- `configure-ovs.sh`: A cloud-init script to install and configure Open vSwitch (OVS) on deployed machines.
- `netplan-config.yaml`: Example Netplan configuration files for various network setups.
- `preseed/`: A directory containing custom preseed files for MAAS deployments.

### Usage

To use these scripts in your MAAS deployments, follow these steps:
1. Clone the repository to your local machine:
   ```bash
   git clone https://github.com/hitmanpragalbh/maas-configurations.git
   ```
2. Modify the scripts and configurations as needed to fit your specific requirements.
3. Host the scripts on a web server or use the raw GitHub URLs in your MAAS preseed configurations.
4. Update your MAAS preseed files to include or reference these scripts during the deployment process.

### Contributions

Contributions are welcome! If you have any improvements or additional scripts that can enhance the functionality of this repository, feel free to open a pull request. Please ensure that your contributions adhere to the existing coding style and include appropriate documentation.

### License

This repository is licensed under the MIT License. See the `LICENSE` file for more details.
