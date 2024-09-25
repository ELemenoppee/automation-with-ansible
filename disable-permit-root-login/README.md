# Disabling Root Permit Login on EC2 Instance Using Ansible

## Description

This guide outlines how to disable root user login via SSH on an EC2 instance using Ansible. Disabling root login enhances security by encouraging the use of regular user accounts for remote access.

## Prerequisites

To successfully follow this guide, you will need the following:

+ Ansible Installed: Ensure Ansible is installed on your control machine.

+ Target EC2 Instance: An EC2 instance with SSH access configured.

+ SSH Access: Make sure you can connect to the EC2 instance via SSH and have the necessary permissions.

## Running the Playbook

### Clone the Ansible Repository

First, clone the repository containing the necessary playbook files to your local machine by running the following command:

```bash
https://github.com/ELemenoppee/automation-with-ansible
```

### Navigate to the Relevant Directory

Once the repository is cloned, navigate to the folder containing the playbook for disabling root login:

```bash
cd automation-with-ansible/disable-permit-root-login/
```

### Edit the Inventory File

Before running the playbook, update the inventory file with the necessary details. Open the file using a text editor:

```bash
vi inventory
```

In this file, replace placeholders such as <REMOTE_IP> with the actual IP address of your EC2 instance, and <username> with the username you will use for SSH access.

### Run the Ansible Playbook

After modifying the inventory file, you can execute the playbook. This command will prompt you for the 'become' password, which is required to escalate privileges on the remote instance:

```bash
ansible-playbook -i inventory playbook.yaml --ask-become-pass
```

This playbook will connect to your EC2 instance, update the SSH configuration to disable root login, and ensure enhanced security for your server.