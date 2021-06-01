data "aws_ami" "ubuntu_18_04" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

resource "random_id" "ec2-instance" {
  byte_length = 2
  count       = var.instance_count
}

resource "aws_instance" "matiu-ec2-instance" {
  count         = var.instance_count
  instance_type = var.instance_type
  ami           = data.aws_ami.ubuntu_18_04.id
  tags = {
    Name = "matiu-node-${random_id.ec2-instance[count.index].dec}"
  }
  vpc_security_group_ids = [var.public_sg]
  subnet_id              = var.public_subnets[count.index]
  root_block_device {
    volume_size = var.vol_size
  }
}
