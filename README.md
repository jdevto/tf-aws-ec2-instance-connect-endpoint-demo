# 🚀 AWS EC2 Instance Connect Endpoint Terraform Demo

This Terraform configuration deploys **Amazon Linux 2 and Amazon Linux 2023 EC2 instances** with **EC2 Instance Connect Endpoint**, allowing secure remote access **without SSH key pairs or public IPs**.

---

## **📌 Features**

✅ **EC2 instances in a private subnet** (no public IPs required)
✅ **Uses EC2 Instance Connect Endpoint** for secure remote access
✅ **No need for SSH key pairs** (access via AWS CLI or Console)
✅ **VPC, Private Subnet, Security Group, IAM Role configuration included**

---

## **📂 Project Structure**

```plaintext
.
├── main.tf                  # Terraform configuration (VPC, EC2, IAM, Security Groups)
└── README.md                # Documentation (this file)
```

---

## **🛠 Prerequisites**

Before deploying, ensure you have:

- **Terraform** installed ([Download](https://developer.hashicorp.com/terraform/downloads)).
- **AWS CLI** installed ([Setup Guide](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)).
- **AWS Credentials** configured (`~/.aws/credentials` or environment variables).

### **🔹 EC2 Instance Connect Endpoint Requirements**

✅ **EC2 instances must be in a private subnet**.
✅ **Security Group must allow inbound SSH from the EC2 Instance Connect Endpoint**.
✅ **EC2 Instance Connect Endpoint must be deployed in the same subnet as the EC2 instance**.

---

## **🚀 Deployment Steps**

### **1️⃣ Clone the Repository (If Applicable)**

```sh
git clone git@github.com:jdevto/tf-aws-ec2-instance-connect-endpoint-demo.git
```

### **2️⃣ Initialize Terraform**

```sh
terraform init
```

### **3️⃣ Preview Changes Before Applying**

```sh
terraform plan
```

### **4️⃣ Deploy EC2 Instances with EC2 Instance Connect Endpoint**

```sh
terraform apply -auto-approve
```

---

## **🔹 Connecting to Instances via EC2 Instance Connect**

Once the deployment is complete, connect to the instances **without SSH key pairs** using the AWS CLI:

```sh
aws ec2-instance-connect ssh --instance-id i-xxxxxxxxxxxxxxxxx
```

🔹 **Find your instance ID** in the AWS Console under **EC2 → Instances**.

You may see the following prompt:

```plaintext
The authenticity of host '10.0.2.129 (<no hostip for proxy command>)' can't be established.
ED25519 key fingerprint is SHA256:AA:BB:CC:DD:EE:FF:11:22:33:44:55:66:77:88:99:00
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.0.2.129' (ED25519) to the list of known hosts.
```

Simply type `yes` and press Enter to continue the connection.

You can also connect through the AWS Console:

1. Navigate to **EC2 → Instances**.
2. Select the instance.
3. Click **Connect** → **EC2 Instance Connect**.
4. Click **Connect**.

---

## **🛑 Cleanup**

To **destroy all resources** created by this demo, run:

```sh
terraform destroy -auto-approve
```

---

## **🔹 Troubleshooting EC2 Instance Connect Issues**

### **❌ Cannot Connect via EC2 Instance Connect**

✅ Ensure the **EC2 instance security group allows SSH (port 22) from the EC2 Instance Connect Endpoint**.
✅ **Instance must be in the same subnet as the EC2 Instance Connect Endpoint**.
✅ **EC2 Instance Connect Endpoint must be deployed correctly**.
✅ **Use the correct AWS CLI command with `aws ec2-instance-connect ssh --instance-id`**.

---

## **📌 Notes**

- **No SSH key pairs are required**, improving security.
- **EC2 Instance Connect Endpoint allows SSH access within a VPC without exposing instances to the internet**.
- **Ensure AWS CLI is installed and configured** before using `aws ec2-instance-connect ssh --instance-id`.

---

## **📧 Need Help?**

If you have any issues, feel free to open an **issue** or reach out! 🚀
