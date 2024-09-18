# teleport-demos
Creating Demos of Teleport features

## Configure Teleport resources

1. Create `terraform.tfvars`

```
teleport_proxy_address = "example.teleport.sh"
teleport_identity_path = "/home/identity"
teleport_user          = "user@goteleport.com"
ssh_key_name           = "demo-se-key"
teleport_version       = "16.2.0"
teleport_cdn_link      = "https://cdn.teleport.dev/install-v16.2.0.sh"
github_client_secret   = "thisclientsecret"
github_client_id       = "thisclientid"
github_org             = "this-org"
aws_region             = "us-west-2"
aws_account_id         = "1234567890"
aws_teleport_profile   = "teleport-roles-anywhere"
aws_tags  = {
      "teleport.dev/creator" = "user@goteleport.com"
      "team"                 = "solutions engineering"
      "purpose"              = "demo"
      "Name"                 = "User SE Demo"
    }
```

2. Enable Teleport resources to be created

Resources set to true will be created in the cluster specified in the Teleport Cluster
```hcl
locals {
  teleport = {
    ssh            = true
    rdp            = false
    aws            = true
    rds            = true
    auto_discovery = false
  }
}
```

## Authenticate Providers

### Log into Teleport Cluster

```sh
tsh login --proxy=example.teleport.sh:443 --auth=okta
```

### Create identity file

```sh
tctl auth sign \
 --user=peter.oneill@goteleport.com --format=file \
 --out=/Users/home/identity \
 --ttl 10h
 ```


### Create AWS spiffe certificate

[spiffe setup](https://goteleport.com/docs/enroll-resources/machine-id/workload-identity/aws-roles-anywhere/#step-24-configure-teleport-rbac)

```sh
tsh svid issue --output /Users/home/svid \
  --svid-ttl 10h \
  /svc/peter-terraform
```


## Modify cluster auth for roles

```sh
tctl edit cluster_auth_preference
```