
module "network" {
  source = "../../modules/network"

  name_prefix = local.name_prefix
  tags        = local.common_tags
}

module "alb" {
  source = "../../modules/alb"

  name_prefix       = local.name_prefix
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  target_port       = 80
  health_check_path = "/"

  tags = local.common_tags
}

module "ecs" {
  source = "../../modules/ecs"

  name_prefix           = local.name_prefix
  vpc_id                = module.network.vpc_id
  private_subnet_ids    = module.network.private_subnet_ids
  alb_security_group_id = module.alb.alb_security_group_id
  target_group_arn      = module.alb.target_group_arn

  container_image = "nginx:stable"
  container_port  = 80
  desired_count   = 2

  tags = local.common_tags
}

module "rds" {
  source = "../../modules/rds"

  name_prefix           = local.name_prefix
  vpc_id                = module.network.vpc_id
  private_subnet_ids    = module.network.private_subnet_ids
  ecs_security_group_id = module.ecs.ecs_security_group_id

  db_name        = "hotel_booking"
  db_username    = "dbadmin"
  db_password    = var.db_password
  instance_class = "db.t3.micro"

  tags = local.common_tags
}
