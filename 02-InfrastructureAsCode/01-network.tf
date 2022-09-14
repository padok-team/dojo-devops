#####################
### IP Subnetting ###
#####################

module "subnets" {
  source = "hashicorp/subnets/cidr"

  base_cidr_block = local.context.vpc.cidr
  networks = [
    {
      name     = "pub-1"
      new_bits = 4
    },
    {
      name     = "pub-2"
      new_bits = 4
    },
    {
      name     = "priv-1"
      new_bits = 2
    },
    {
      name     = "priv-2"
      new_bits = 2
    }
  ]
}

#####################
### VPC & Subnets ###
#####################

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${local.context.owner}-${local.context.env}"
  cidr = local.context.vpc.cidr

  azs = local.context.vpc.availability_zone

  public_subnets = [
    module.subnets.network_cidr_blocks["pub-1"],
    module.subnets.network_cidr_blocks["pub-2"]
  ]
  private_subnets = [
    module.subnets.network_cidr_blocks["priv-1"],
    module.subnets.network_cidr_blocks["priv-2"]
  ]

  enable_nat_gateway = true

  tags = local.context.tags
}
