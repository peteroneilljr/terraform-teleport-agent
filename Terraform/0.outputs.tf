output "vpc_id" {
  value = module.vpc.vpc_id
}
output "public_subnets" {
  value = module.vpc.public_subnets
}
output "private_subnets" {
  value = module.vpc.private_subnets
}
output "aws_key_pair" {
  value = aws_key_pair.peter.id
}
output "default_security_group_id" {
  value = module.vpc.default_security_group_id
}