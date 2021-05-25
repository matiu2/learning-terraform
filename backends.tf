terraform {
  backend "remote" {
    organization = "matiu"
    workspaces {
      name = "matiu-dev"
    }
  }
}
