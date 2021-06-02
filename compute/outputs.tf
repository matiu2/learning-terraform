output "instances" {
  value = [for instance in aws_instance.matiu-ec2-instance : {
    instance_id = instance.id
    name        = instance.tags.Name,
    key_name    = instance.key_name,
    public_ip   = instance.public_ip
  }]
}
