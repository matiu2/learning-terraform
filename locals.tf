locals {
  security_groups = {
    public = {
      name                  = "public-sg",
      description           = "Security group for public access",
      allowed_ingress_ports = [80, 443]
      ingress_rules = {
        ssh = {
          from        = 22
          to          = 22
          protocol    = "tcp"
          cidr_blocks = [var.ssh_access_cidr]
        },
      },
    },
  }
}
