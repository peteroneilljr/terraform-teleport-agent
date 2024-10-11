# Examples


## AWS Cloud Access
```hcl
module "teleport_aws" {
  source = "github.com/peteroneilljr/terraform-teleport-node"

  create = true

  cloud = "AWS"

  aws_vpc_id            = module.vpc.vpc_id
  aws_security_group_id = module.vpc.default_security_group_id
  aws_subnet_id         = module.vpc.private_subnets[0]

  teleport_agent_roles = ["App"]

  teleport_proxy_address = var.teleport_proxy_address
  teleport_version       = var.teleport_version
  teleport_ssh_labels = {
    "type" = "agent"
  }

  aws_key_pair         = aws_key_pair.keyname.id
  aws_instance_profile = aws_iam_instance_profile.console_access.name

  agent_nodename = "aws-agent"

  teleport_aws_apps = {
    "awsconsole" = {
      "uri" = "https://console.aws.amazon.com/"
      "labels" = {
        "cloud" = "aws"
        "env"   = "dev"
      }
    }
    "awsconsole-admin" = {
      "uri" = "https://console.aws.amazon.com/"
      "labels" = {
        "cloud" = "aws"
        "env"   = "prod"
      }
    }
  }

}
```

## GCP CLI Access

```hcl
module "teleport_gcp" {
  source = "github.com/peteroneilljr/terraform-teleport-node"

  create = true

  cloud  = "GCP"
  prefix = "pon"

  teleport_proxy_address = var.teleport_proxy_address
  teleport_version       = var.teleport_version
  teleport_ssh_labels = {
    "type" = "agent"
  }
  teleport_agent_roles = ["App"]

  agent_nodename = "gcp-agent"

  gcp_service_account_email = google_service_account.teleport_cli.email
  gcp_machine_type          = "e2-micro"
  gcp_region                = var.gcp_region
  teleport_gcp_apps = {
    "google-cloud-cli" = {
      "labels" = {
        "cloud" = "gcp"
      }
    }
  }
}
```

## Node Setup

```hcl
module "dev_central" {
  source = "github.com/peteroneilljr/terraform-teleport-node"

  create = true

  cloud = "AWS"

  aws_vpc_id            = module.vpc.vpc_id
  aws_security_group_id = module.vpc.default_security_group_id
  aws_subnet_id         = module.vpc.private_subnets[0]

  agent_nodename = "dev-central"

  teleport_ssh_labels    = { "env" = "dev" }
  teleport_proxy_address = var.teleport_proxy_address
  teleport_version       = var.teleport_version
  teleport_agent_roles   = []

  aws_key_pair = aws_key_pair.keyname.id

}
```


## Windows Node

```hcl
module "teleport_rdp" {
  source = "github.com/peteroneilljr/terraform-teleport-node"

  create = true

  cloud = "AWS"

  aws_vpc_id            = module.vpc.vpc_id
  aws_security_group_id = module.vpc.default_security_group_id
  aws_subnet_id         = module.vpc.private_subnets[0]

  agent_nodename = "win-agent"

  teleport_proxy_address = var.teleport_proxy_address
  teleport_version       = var.teleport_version
  teleport_ssh_labels = {
    "type" = "agent"
  }

  teleport_agent_roles = ["WindowsDesktop"]

  teleport_windows_hosts = {
    "development" = {
      "env"  = "dev"
      "addr" = local.teleport.rdp ? module.windows_instances["dev"].private_ip : "1.1.1.1"
    }
    "production" = {
      "env"  = "prod"
      "addr" = local.teleport.rdp ? module.windows_instances["prod"].private_ip : "1.1.1.1"
    }
  }

  aws_key_pair = aws_key_pair.keyname.id

}
```

## RDS Postgres

```hcl
module "rds_teleport" {
  source = "github.com/peteroneilljr/terraform-teleport-node"

  create = true

  cloud = "AWS"

  aws_vpc_id            = module.vpc.vpc_id
  aws_security_group_id = module.vpc.default_security_group_id
  aws_subnet_id         = module.vpc.private_subnets[0]

  aws_key_pair         = aws_key_pair.keyname.id
  aws_instance_profile = aws_iam_instance_profile.rds_postgresql.name


  agent_nodename = "rds-agent"

  teleport_proxy_address = var.teleport_proxy_address
  teleport_version       = var.teleport_version
  teleport_ssh_labels = {
    "type" = "agent"
  }

  teleport_agent_roles = ["Db"]

  teleport_rds_hosts = local.teleport.rds ? local.rds_hosts : {}

}

locals {
  rds_hosts = {
    "db-dev1" = {
      "env"      = "dev"
      "endpoint" = module.rds_postgresql.db_instance_endpoint
      "address"  = module.rds_postgresql.db_instance_address
      "admin"    = module.rds_postgresql.db_instance_username
      "users"    = ["developer", "reader"]
      "database" = module.rds_postgresql.db_instance_name
      "password" = random_password.rds.result
    }
    "db-dev2" = {
      "env"      = "dev"
      "endpoint" = module.rds_postgresql.db_instance_endpoint
      "address"  = module.rds_postgresql.db_instance_address
      "admin"    = module.rds_postgresql.db_instance_username
      "users"    = ["developer", "reader"]
      "database" = module.rds_postgresql.db_instance_name
      "password" = random_password.rds.result
    }
    "db-production" = {
      "env"      = "prod"
      "endpoint" = module.rds_postgresql.db_instance_endpoint
      "address"  = module.rds_postgresql.db_instance_address
      "admin"    = module.rds_postgresql.db_instance_username
      "users"    = ["developer", "reader"]
      "database" = module.rds_postgresql.db_instance_name
      "password" = random_password.rds.result
    }
  }
}
```