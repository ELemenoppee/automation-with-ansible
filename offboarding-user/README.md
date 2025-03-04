# Offboard User, Backup Home Directory, and Transfer to Ansible Control Node

## Overview
This Ansible playbook automates the process of offboarding a user from a system. It performs the following tasks:
- Archives the user's home directory.
- Fetches the archive to the Ansible control node.
- Optionally uploads the archive to an AWS S3 bucket.
- Either removes the user or disables their account, based on the selected option.

## Prerequisites
- Ansible installed on the control node.
- AWS CLI installed on the control node (if using S3 backup).
- SSH access to the target hosts.

## Playbook Structure
This playbook consists of two plays:
1. **Running on target hosts**:
   - Captures user input (username, S3 bucket, AWS credentials, etc.).
   - Archives the user's home directory.
   - Fetches the archive to the Ansible control node.
   - Either removes or disables the user account.
2. **Running on localhost (Ansible control node)**:
   - Uploads the archive to S3 (if configured).

## Usage
### 1. Clone the Repository
```sh
git clone https://github.com/ELemenoppee/automation-with-ansible.git
cd offboarding-user
```

### 2. Run the Playbook
```sh
ansible-playbook playbook.yaml -i inventory --ask-become-pass
```

### 3. Input Required Information
During execution, you will be prompted to provide:
- **Username** of the user to offboard.
- **Whether to remove the home directory** (yes/no).
- **S3 bucket name** (leave empty to skip S3 backup).
- **AWS Access Key ID** (if using S3 backup).
- **AWS Secret Access Key** (if using S3 backup).
- **AWS Region** (if using S3 backup).

## Inventory
Ensure your `inventory` file includes the target hosts. Example:
```
[servers]
192.168.1.100 ansible_host=192.168.1.100 ansible_user=admin
```

## Workflow
1. If `remove_home` is set to `yes`, the user's home directory is archived and removed.
2. If `remove_home` is set to `no`, the user's account is disabled instead of deleted.
3. The home directory archive is fetched to the Ansible control node.
4. If an S3 bucket name is provided, the archive is uploaded to S3.

## Requirements
- Linux-based target hosts.
- AWS credentials with appropriate permissions (if using S3 backup).
- Ansible control node with `fetch` module enabled.

## Notes
- The playbook requires `become: true` to manage user accounts and files.
- AWS credentials are passed using `vars_prompt`, ensuring security.
- This playbook does not manage S3 bucket creation; ensure the bucket exists beforehand.
