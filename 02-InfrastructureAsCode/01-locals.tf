locals {

  owner   = "FIX_ME" # lower case only
  my_cidr = "FIX_ME" # (x.x.x.x/xx)
  my_ip   = "${jsondecode(data.curl.public_ip.response)["ip"]}/32"
  context = {

    owner  = local.owner
    env    = "dojo"
    region = "eu-west-3"

    tags = {
      Name = "${local.owner}-dojo"
    }

    vpc = {
      availability_zone = ["eu-west-3a", "eu-west-3b"]
      cidr              = local.my_cidr
    }
  }

  # uncomment later
  #eks = {
  #  cluster = {
  #    name    = local.owner
  #    version = "1.21"
  #  }
  #  node = {
  #    name           = "eks_node"
  #    capacity_type  = "SPOT"
  #    instance_types = ["t3a.xlarge", "c5a.xlarge", "t3.xlarge", "c5.xlarge", "c6i.xlarge", "m5a.xlarge"]
  #    scaling_config = {
  #      min_size     = 1
  #      max_size     = 10
  #      desired_size = 1
  #    }
  #  }
  #}

  # uncomment later
  #ecr_name = "${local.owner}/demo-k8s"
}

data "curl" "public_ip" {
  http_method = "GET"
  uri         = "https://ipinfo.io"
}
