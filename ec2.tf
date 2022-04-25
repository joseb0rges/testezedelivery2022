module "ec2" {
  source         = "./modules/ec2"
#  instance_count = 1
  ami            = "ami-04505e74c0741db8d"
  instance_type  = "t3.medium"
  subnet_id      = module.networking.private_subnet_ids[0]
  vpc_id = module.networking.vpc_id
  cidr_block_priv = "10.20.0.0/23"
  private_ip = "10.20.0.30"
  tags = {
    environment = lab
    owner = "Jose Borges"
    LabID = "98981602022"
  }

  
}