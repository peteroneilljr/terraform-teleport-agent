module "dev_central" {
  source = "../modules/terraform-teleport-agent-v2"

  create = local.teleport.ssh

  vpc_id                = module.vpc.vpc_id
  vpc_security_group_id = module.vpc.default_security_group_id
  vpc_subnet_id         = module.vpc.private_subnets[0]

  agent_nodename = "dev-central"

  teleport_ssh_labels    = { "env" = "dev" }
  teleport_proxy_address = var.teleport_proxy_address
  teleport_version       = var.teleport_version

  aws_key_pair = aws_key_pair.peter.id

}

module "dev_east" {
  source = "../modules/terraform-teleport-agent-v2"

  create = local.teleport.ssh

  vpc_id                = module.vpc.vpc_id
  vpc_security_group_id = module.vpc.default_security_group_id
  vpc_subnet_id         = module.vpc.private_subnets[0]

  agent_nodename = "dev-east"

  teleport_ssh_labels    = { "env" = "dev" }
  teleport_proxy_address = var.teleport_proxy_address
  teleport_version       = var.teleport_version

  aws_key_pair = aws_key_pair.peter.id

}

module "prod1" {
  source = "../modules/terraform-teleport-agent-v2"

  create = local.teleport.ssh

  vpc_id                = module.vpc.vpc_id
  vpc_security_group_id = module.vpc.default_security_group_id
  vpc_subnet_id         = module.vpc.private_subnets[2]

  agent_nodename = "prod1"

  teleport_ssh_labels    = { "env" = "prod" }
  teleport_proxy_address = var.teleport_proxy_address
  teleport_version       = var.teleport_version

  aws_key_pair = aws_key_pair.peter.id

}

