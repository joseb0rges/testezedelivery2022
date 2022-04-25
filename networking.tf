module "networking" {
  source         = "./modules/networking"
  vpc_cidr_block = "10.20.0.0/20"
  public_subnets = [
    { cidr_block = "10.20.2.0/23", zone = "us-east-1a", name = "subnet-a-pub1" }
  ]

  private_subnets = [
    { cidr_block = "10.20.0.0/23", zone = "us-east-1a", name = "subnet-a-priv1" }
  ]
  customer_group = "mb"
  env            = "dev1"

  tags = {
    Environment = "development"
    Name        = "my-tag"
  }
}
