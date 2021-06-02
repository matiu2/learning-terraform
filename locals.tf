locals {
  security_groups = {
    public = {
      name                  = "public-sg",
      description           = "Security group for public access",
      allowed_ingress_ports = [80, 443, 8000]
      ingress_rules = {
        ssh = {
          from        = 22
          to          = 22
          protocol    = "tcp"
          cidr_blocks = [var.ssh_access_cidr]
        },
      },
    },
    rds = {
      name                  = "rds-sg"
      description           = "Security group for the RDS instances"
      allowed_ingress_ports = []
      ingress_rules = {
        mysql = {
          from        = 3306
          to          = 3306
          protocol    = "tcp"
          cidr_blocks = [var.vpc_cidr]
        }
      }

    }

  }
}
