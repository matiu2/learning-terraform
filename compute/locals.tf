locals {
  ec2-instance-names = [for i in range(0, var.instance_count) : "matiu-node-${random_id.ec2-instance[i].dec}"]
}
