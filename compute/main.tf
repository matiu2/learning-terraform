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
  ami           = var.ami_id
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
    nodename     = local.ec2-instance-names[count.index]
    db_endpoint  = var.db_endpoint
    dbuser       = var.db_username
    dbpass       = var.db_password
    dbname       = var.db_name
    ssh_key_path = var.ssh_key_path
  })
  lifecycle {
    create_before_destroy = true
  }
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = self.public_ip
      private_key = file(var.ssh_key_path)
    }
    script = "${path.cwd}/delay.sh"
  }
  provisioner "local-exec" {
    command = templatefile("${path.cwd}/scp_script.tpl", {
      nodeip       = self.public_ip
      k3s_path     = "${path.cwd}/.."
      nodename     = self.tags.Name
      ssh_key_path = var.ssh_key_path
    })
  }
  provisioner "local-exec" {
    when        = destroy
    working_dir = "${path.cwd}/.."
    command     = "rm -f k3s-${self.tags.Name}.yaml"
  }
}

resource "aws_lb_target_group_attachment" "tg_attach" {
  count            = var.instance_count
  target_group_arn = var.aws_lb_target_group_arn
  target_id        = aws_instance.matiu-ec2-instance[count.index].id
  port             = 8000
}
