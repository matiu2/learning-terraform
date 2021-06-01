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

resource "aws_key_pair" "ssh-pub-key" {
  key_name   = var.ssh-pub-key-name
  public_key = file(var.ssh-pub-key-path)
}

resource "aws_instance" "matiu-ec2-instance" {
  count         = var.instance_count
  instance_type = var.instance_type
  ami           = data.aws_ami.ubuntu_18_04.id
  tags = {
    Name = local.ec2-instance-names[count.index]
  }
  vpc_security_group_ids = [var.public_sg]
  subnet_id              = var.public_subnets[count.index]
  root_block_device {
    volume_size = var.vol_size
  }
  key_name = aws_key_pair.ssh-pub-key.key_name
  user_data = templatefile(var.user_data_tmpl_path, {
    nodename    = local.ec2-instance-names[count.index]
    db_endpoint = var.db_endpoint
    dbuser      = var.db_username
    dbpass      = var.db_password
    dbname      = var.db_name
  })
  lifecycle {
    create_before_destroy = true
  }
}
