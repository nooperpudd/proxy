variable "ami_id" {
  type = string
  # ubuntu anonical, Ubuntu, 18.04 LTS, amd64 bionic image
  default = "ami-01d4e30d4d4952d0f"
}

variable "vpc_id" {
  type = string
}
variable "subnet_id" {
  type = string
}

variable "ec2_instance_type" {
  type = string
  default = "m5.large"
}

variable "jump_host_secruity_group_id" {
  type = string
}
variable "ssh_key_name" {
  type = string
}
variable "secrity-group-ip-address" {
  type = list(string)
  default = []
}
variable "proxy-server-public-ip" {
  type = string
}
variable "proxy-client-public-ip-id" {
  type = string
  default = "eipalloc-59117e63"
}