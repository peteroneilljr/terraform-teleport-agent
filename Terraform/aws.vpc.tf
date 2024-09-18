module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "peter-se-demo"
  cidr = "10.7.0.0/16"

  azs = ["us-west-2a", "us-west-2b", "us-west-2c"]
  private_subnets = [
    "10.7.1.0/24", "10.7.2.0/24", "10.7.3.0/24", # SSH
    "10.7.11.0/24",                              # RDP
    "10.7.21.0/24",                              # Auto Discovery
  ]
  public_subnets = ["10.7.101.0/24", "10.7.102.0/24", "10.7.103.0/24"]


  # todo create database subnet
  # https://github.com/terraform-aws-modules/terraform-aws-rds/blob/master/examples/complete-postgres/main.tf
  # database_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 6)]
  # create_database_subnet_group = true

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_dns_hostnames    = true
  enable_dns_support      = true
  map_public_ip_on_launch = true

  default_security_group_egress = [
    {
      # allow egress
      cidr_blocks = "0.0.0.0/0",
      "from_port" : 0,
      "to_port" : 0,
      "protocol" : "-1"
    }
  ]
  default_security_group_ingress = [
    {
      # Postgresql
      cidr_blocks = "0.0.0.0/0",
      "from_port" : 5432,
      "to_port" : 5432,
      "protocol" : "tcp"
    },
    {
      # mysql
      cidr_blocks = "0.0.0.0/0",
      "from_port" : 3306,
      "to_port" : 3306,
      "protocol" : "tcp"
    },
    {
      # rdp
      cidr_blocks = "0.0.0.0/0",
      "from_port" : 3389,
      "to_port" : 3389,
      "protocol" : "tcp"
    },
    {
      # SSH
      cidr_blocks = "0.0.0.0/0",
      "from_port" : 22,
      "to_port" : 22,
      "protocol" : "tcp"
    },
    {
      # internal traffic
      cidr_blocks = "10.7.0.0/16",
      "from_port" : 0,
      "to_port" : 0,
      "protocol" : "-1"
    }
  ]
}
