#!/bin/bash

# Prompt user for inventory file name
read -p "Enter the inventory file name: " inventory_file

# Run ansible-playbook commands with error handling
ansible_playbook_command="ansible-playbook -i $inventory_file"

$ansible_playbook_command install-k8s.yaml -i $inventory_file
if [ $? -ne 0 ]; then
    echo "Error encountered in install-k8s.yaml playbook. Exiting."
    exit 1
fi

$ansible_playbook_command display-token.yaml
if [ $? -ne 0 ]; then
    echo "Error encountered in display-token.yaml playbook. Exiting."
    exit 1
fi

$ansible_playbook_command join-workers.yaml
if [ $? -ne 0 ]; then
    echo "Error encountered in join-workers.yaml playbook. Exiting."
    exit 1
fi

$ansible_playbook_command customized-containerd-config.yaml
if [ $? -ne 0 ]; then
    echo "Error encountered in customized-containerd-config.yaml playbook. Exiting."
    exit 1
fi

echo "All playbooks executed successfully."
