resource "aws_security_group" "proxy_server_security_group" {
  name = "China proxy security group"
  vpc_id = var.vpc_id
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    security_groups = [
      var.jump_security_group_id]
  }
  ingress {
    from_port = 555
    protocol = "tcp"
    to_port = 555
    cidr_blocks = var.security_group_proxy_client_ip_list
  }
  tags = {
    Name = "china-proxy-secrity-group"
    Envronment = "Production"
  }

}

# aws EIP
resource "aws_eip" "proxy_public_ip" {
  # aws eip
  vpc = true
  instance = aws_instance.proxy_server.id
}

# cloud init user data
data "template_file" "proxy-server-init-template" {
  template = file("${path.module}/script/cloud-init.tpl")
}


data "template_cloudinit_config" "proxy-server-init" {

  base64_encode = true
  part {
    content = data.template_file.proxy-server-init-template.rendered
  }
}

# end cloud init user data

resource "aws_instance" "proxy_server" {
  # aws instance configuration

  ami = var.ami_id
  instance_type = var.ec2_instance_type
  vpc_security_group_ids = [
    aws_security_group.proxy_server_security_group.id]
  key_name = var.ssh_key_name

  tags = {
    Name = "china-proxy-server"
    Envronment = "Production"
  }

  user_data_base64 = data.template_cloudinit_config.proxy-server-init.rendered
}



