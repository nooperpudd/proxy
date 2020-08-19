variable "ami_id" {
  type = string
  # us-east-1 region,  Ubuntu Server 18.04 LTS 64-bit x86
  default = "ami-04b9e92b5572fa0d1"
  description = "AWS AMI id"
}

variable "environment" {
  type = string
  default = "Production"
}
variable "instance_subnet" {
  type = list(string)
  description = "Proxy server subnet list"
}
variable "jump_security_group_id" {
  type = string
  description = "AWS jump host security group arn id"
}

variable "ec2_instance_type" {
  type = string
  default = "m5.large"
  description = "AWS ec2 instance type, default m5.large"
}

variable "vpc_id" {
  type = string
  default = "AWS VPC id"
}
variable "ssh_key_name" {
  type = string
  description = "Name of the SSH keypair to use in AWS."
}
variable "security_group_proxy_client_ip_list" {
  type = list(string)
  default = []
  description = "add whilelist ip address to secruity group"
}

