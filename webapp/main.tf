module "network_config" {
  source = "../terraform-modules/aws-network"

  vpc_cidr          = var.vpc_cidr
  enable_vpc_dns    = var.enable_vpc_dns
  subnet_count      = var.subnet_count
  subnet_bits       = var.subnet_bits
  project_name      = var.project_name
  env               = var.env
}

module "servers_config" {
  source = "../terraform-modules/aws-servers"

  ec2_ami_id            = var.ec2_ami_id
  ec2_instance_type     = var.ec2_instance_type
  security_group_id     = module.network_config.security_group_id
  vpc_id                = module.network_config.vpc_id
  private_subnet_ids    = module.network_config.private_subnet_ids
  public_subnet_ids     = module.network_config.public_subnet_ids
  min_instance_count    = var.min_instance_count
  max_instance_count    = var.max_instance_count

  depends_on            = [module.network_config]
}

module "db_config" {
  source = "../terraform-modules/aws-db"

  public_subnet_ids     = module.network_config.public_subnet_ids
  db_storage_size       = var.db_storage_size
  db_storage_type       = var.db_storage_type
  security_group_id     = module.network_config.security_group_id
  db_engine_type        = var.db_engine_type
  db_engine_version     = var.db_engine_version
  db_instance_class     = var.db_instance_class
  db_name               = var.db_name
  db_username           = var.db_username
  db_password           = var.db_password

  depends_on            = [module.servers_config]
}