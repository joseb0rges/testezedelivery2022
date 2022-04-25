variable "instance_type" {
  type = string
}

variable "ami" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "private_ip" {}

variable "tags" {
  type = map(string)
}


variable "keyname"{
  default = "ssh_key"
}


variable "cidr_block_priv" {

}


variable "vpc_id" {}