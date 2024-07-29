# 🐙 Kubernetes PVC Backup to AWS S3 Automation 🐙


This repository offers an automated implementation of the procedure detailed in the guide: Kubernetes PVC Backup to AWS S3 with Restic.

https://github.com/ELemenoppee/devops-config-install/blob/main/kubernetes/k8-pvcs-s3-with-restic.md

It contains automation scripts to back up Kubernetes Persistent Volume Claims (PVCs) to AWS S3 using Ansible. The solution ensures secure and reliable backup of your Kubernetes PVC data to AWS S3, protecting your critical information.

## Features 🦑

+ **Automated Backup:** Regularly backs up PVC data from your Kubernetes cluster to AWS S3.

+ **Configurable:** Easily configure backup schedules, S3 bucket details, and other parameters.

## Prerequisites 🐦

+ **AWS Account:** An AWS account with permissions to create and manage S3 buckets.

+ **Ansible Server:** Used for automating the backup process.

## Pre-Steps:- 🐻‍❄️

Before running the Ansible playbook, ensure the following steps are completed to guarantee proper functionality:

### **Step 1** — Create an Amazon S3 Bucket

First, create an S3 bucket for your backup and recovery backend, along with the required permissions to access the bucket. Use the following command:

```
aws s3api create-bucket --bucket <BUCKET_NAME> --region <REGION> --create-bucket-configuration LocationConstraint=<REGION>
```

**Note:** Replace <__REGION__> with your target AWS Region and <__BUCKET_NAME__> for the bucket name.

For Example:

```
aws s3api create-bucket --bucket k8s-master-01-backup-pvc --region ap-southeast-2 --create-bucket-configuration LocationConstraint=ap-southeast-2
```

You can confirm the created S3 bucket at:

```
https://<REGION>.console.aws.amazon.com/s3/home?region=<REGION>
```

### **Step 2** — Create a User with Required Access to S3 Bucket

After creating the backup and recovery S3 bucket, create an IAM user and attach the required policy to allow access to the bucket.

First, create a file named restic-policy.json and paste the following config into it:

*restic-policy.json*:
```bash
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Action": [
				"s3:PutObject",
				"s3:ListBucket",
				"s3:GetObject",
				"s3:DeleteObject"
			],
			"Resource": [
				"arn:aws:s3:::<BUCKET_NAME>",
				"arn:aws:s3:::<BUCKET_NAME>/*"
			]
		}
	]
}
```

**Note:** Please change the <__BUCKET_NAME__> in the restic-policy.json file.

For Example:
```
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Action": [
				"s3:PutObject",
				"s3:ListBucket",
				"s3:GetObject",
				"s3:DeleteObject"
			],
			"Resource": [
				"arn:aws:s3:::k8s-worker-01-backup-pvc",
				"arn:aws:s3:::k8s-worker-01-backup-pvc/*",
				"arn:aws:s3:::k8s-worker-02-backup-pvc",
				"arn:aws:s3:::k8s-worker-02-backup-pvc/*"
			]
		}
	]
}
```

This policy defines the permissions for accessing the S3 bucket. It allows the following actions:

+ `“s3:PutObject”`: This allows for putting or uploading an object to the bucket.

+ `“s3:ListBucket”`: This allows for listing the objects in the bucket.

+ `“s3:GetObject”`: This allows for getting or downloading an object from the bucket.

+ `“s3:DeleteObject”`: This allows for deleting an object from the bucket.

The policy specifies that these actions are allowed with an “Effect” of “Allow”. The “Resource” specifies that these actions can be taken on the bucket itself (“arn:aws:s3:::<_BUCKET_NAME_>”) and on any object within the bucket ("arn:aws:s3:::<_BUCKET_NAME_>/*").

Create user.
```
aws iam create-user --user-name k8s-backup-user
```

Output: 
```
{
    "User": {
        "Path": "/",
        "UserName": "k8s-backup-user",
        "UserId": "AIDARUXW3BEFUZ4VDAEJ2",
        "Arn": "<ARN>",
        "CreateDate": "2024-07-22T01:09:30+00:00"
    }
}
```

Attach the policy to the user.
```
aws iam put-user-policy --user-name k8s-backup-user --policy-name restic-policy --policy-document file://restic-policy.json
```

**Note:** Make sure that **file://restic-policy.json** is set to the location of the json file you created earlier.


This command creates an IAM user with the name “restic-user”. The “&&” operator allows you to chain commands together. So after creating the user, the command attaches a policy to the user with the name “restic-policy”. The policy document is stored in a local file called “restic-policy.json”, and the “aws iam put-user-policy” command is used to attach the policy to the user.

A Restic IAM user has been created and policy attached. Next, you need to create the programmatic access key. Restic will use this key to assume the user’s identity. To do so, run the following command:

```
aws iam create-access-key --user-name k8s-backup-user
```

Store the AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY in a safe place, as we’ll use them in the next steps.

## Steps:-

**Step 1** — Clone the Repository

Start by cloning the repository to your local machine:

```bash
$ git clone https://github.com/ELemenoppee/automation-with-ansible.git
$ cd pvc-backup-restore
   ```

**Step 2** — Update Inventory Values

Next, you’ll need to modify the inventory file with the appropriate values. Open it with your preferred editor:

```bash
$ vi inventory
```

**Note:** Ensure that all required values are updated to reflect your environment.

**Step 3** — Configure the Playbook

Adjust the roles in your playbook by commenting or uncommenting as needed. Open the playbook file for editing:

```bash
$ vi playbook.yaml
```

```bash
  roles:
    # - 'initialize-repository'
    - 'on-demand-backup-s3'
    - 'auto-backup-s3'
    # - 'auto-remove-snapshot'
```

+ initialize-repository: This role is essential for the initial setup. Make sure the S3 bucket is empty before running this.

+ on-demand-backup-s3: Include this role if you need to perform manual backups as needed.

+ auto-backup-s3: Select this role if you want to enable automatic backups to S3.

+ auto-remove-snapshot: Use this role for the initial setup to automatically prune snapshots based on a specified time interval.

**Step 4** — Execute the Playbook

To run the playbook, use the following command:

```bash
$ ansible-playbook playbook.yaml -i inventory --ask-become-pass
```

Make sure to provide any required information as prompted during execution.

## Final Note 🌚

If you find this repository useful for learning, please give it a star on GitHub. Thank you!

**Authored by:** [ELemenoppee](https://github.com/ELemenoppee)