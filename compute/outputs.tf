output "ssh_access" {
  value = [for instance in aws_instance.matiu-ec2-instance : {
    name      = instance.tags.Name,
    key_name  = instance.key_name,
    public_ip = instance.public_ip
  }]
}
