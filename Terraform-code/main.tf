module "vpc" {
  source = "./modules/vpc"
  vpc_cidr_block = var.vpc_cidr_block
  subnet_cidr = var.subnet_cidr
  subnet_names = var.subnet_names
}

module "sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc-id 
  #module.<module name from above>.<output name of vpc id from output.tf>
}

module "ec2" {
  source = "./modules/ec2"
  sg-id = module.sg.sg-id
  subnet-id = module.vpc.subnet-id
  ec2-names = var.ec2-names
}

module "alb" {
  source = "./modules/alb"
  sg-id = module.sg.sg-id
  subnet-id = module.vpc.subnet-id
  vpc-id = module.vpc.vpc-id
  instances = module.ec2.ec2
}