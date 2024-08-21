# Ansible Playbook for Kubernetes Deployment

This repository provides Ansible playbooks designed to deploy Kubernetes clusters. Follow the steps below to execute these playbooks.

## Fresh Install

To perform a fresh Kubernetes installation, follow these steps:

### Prerequisites

1. Create EC2 Instances: Set up two EC2 instances—one for the master node and one for the worker node. You can create these instances using the playbooks found in the ansible/ec2-deployment directory.


### Playbooks

Run the Playbooks: Execute the following playbooks in the specified order:

- `install-k8s.yaml`
- `master-config.yaml`
- `post-config.yaml`
- `join-workers.yaml`
- `customized-containerd-config.yaml`

Alternatively, you can run the following script:

```
chmod +x fresh-install.sh
./fresh-install.sh
```

## Adding Workers to an Existing Master

If the master node is already set up and only worker nodes need to be added, follow these instructions:

### Prerequisites
1. Master Token Verification: Ensure the master token is available at `/tmp/kubernetes_join_command` on the Ansible controller. If the token is missing, follow these steps:

   a. Log in to the master node.
   b. Run the required commands to generate the token, then copy it to the Ansible controller's `/tmp/kubernetes_join_command`.
   c. Adjust the file permissions on the Ansible controller for `/tmp/kubernetes_join_command`.

### Playbook
Join the Worker Nodes: Execute the following playbook to integrate the workers with the master node:

- `join-workers.yaml`

## Inventory File

Here’s an example of what your inventory file might look like:

```ini
[masters]
<MASTER_HOSTNAME> ansible_host=<MASTER_IP_ADDRESS> ansible_user=ubuntu hostname=<MASTER_HOSTNAME>

[workers]
<WORKER_HOSTNAME> ansible_host=<WORKER_IP_ADDRESS> ansible_user=ubuntu hostname=<WORKER_HOSTNAME>
```

