resource "aws_security_group" "proxy_client_security_group" {
  name = "China proxy client security group"
  vpc_id = var.vpc_id
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    security_groups = [
      var.jump_host_secruity_group_id]
  }
  ingress {
    from_port = 3128
    protocol = "tcp"
    to_port = 3128
    cidr_blocks = [
      "10.0.0.0/8"]
  }
  tags = {
    Name = "china-proxy-client"
    Envronment = "Production"
  }
}

# aws EIP
resource "aws_eip_association" "binding-exist-proxy-ip" {
  instance_id = aws_instance.proxy_server.id
  allocation_id = var.proxy-client-public-ip-id
}

# cloud init user data
data "template_file" "proxy-client-init" {
  template = file("${path.module}/script/cloud-init.tpl")
    vars = {
    proxy-server-public-ip = var.proxy-server-public-ip
  }
}


data "template_cloudinit_config" "proxy-client-init" {
  base64_encode = true

  part {
    content = data.template_file.proxy-client-init.rendered
  }
}

# end cloud init user data

resource "aws_instance" "proxy_server" {
  # aws instance configuration
  ami = var.ami_id
  instance_type = var.ec2_instance_type
  vpc_security_group_ids = [
    aws_security_group.proxy_client_security_group.id]
  key_name = var.ssh_key_name

  tags = {
    Name = "china-proxy-client"
    Envronment = "Production"
  }

  user_data_base64 = data.template_cloudinit_config.proxy-client-init.rendered
}



