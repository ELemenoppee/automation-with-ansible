# Manage SSH Authorized Keys with Ansible

## Overview

This Ansible playbook automates the management of SSH authorized keys on remote servers. It allows users to add a new SSH key while removing an old one, ensuring secure access control. The playbook prompts for user input to specify the keys and applies changes accordingly.

## Prerequisites

+ Ansible installed on the control node.

+ SSH access to the target hosts.

+ Ansible inventory file configured with target hosts.

## Playbook Structure

This playbook consists of the following tasks:

+ Prompting for user input: Users provide the new SSH key to be added and the old SSH key to be removed.

+ Adding the new SSH key: The provided key is appended to the authorized_keys file of the target user.

+ Removing the old SSH key: The specified key is removed from authorized_keys, ensuring outdated or compromised keys are revoked.

## Usage

### 1. Clone the Repository

```bash
git clone https://github.com/ELemenoppee/automation-with-ansible.git
cd managing-ssh-authorized-keys-with-ansible\
```

### 2. Run the Playbook

```bash
ansible-playbook playbook.yaml -i inventory
```

### 3. Input Required Information

During execution, you will be prompted to provide:

+ New SSH key to be added.

+ Old SSH key to be removed.

## Inventory

Ensure your inventory file includes the target hosts. Example:

```bash
[machines]
192.168.1.100 ansible_host=192.168.1.100 ansible_user=admin
```

## Playbook Code

```bash
---
- name: Manage SSH Authorized Keys
  hosts: all
  become: false

  vars_prompt:
    - name: new_ssh_key
      prompt: "Enter the new SSH key to add"
      private: false

    - name: old_ssh_key
      prompt: "Enter the SSH key you want to remove"
      private: false

  tasks:
    - name: Add new SSH key to authorized_keys
      ansible.posix.authorized_key:
        user: "{{ ansible_user | default(lookup('env', 'USER')) }}"
        state: present
        key: "{{ new_ssh_key }}"

    - name: Remove specified SSH key from authorized_keys
      ansible.builtin.lineinfile:
        path: ~/.ssh/authorized_keys
        state: absent
        regexp: "{{ old_ssh_key | regex_escape() }}"
```

## Workflow

+ The user runs the playbook and inputs the SSH keys.

+ The playbook updates the authorized_keys file on the target hosts.

+ The new key is added, and the old key is removed.

## Requirements

+ Linux-based target hosts with SSH access.

+ Ansible control node configured with proper inventory.

+ "ansible.posix" module.

```bash
ansible-galaxy collection install ansible.posix
```

## Notes

+ The playbook does not require root privileges (become: false).

+ Ensure the correct user context is used when running the playbook.

+ The playbook only modifies authorized_keys for the specified user.

By using this playbook, you can efficiently manage SSH access, enhancing security and control over your servers.