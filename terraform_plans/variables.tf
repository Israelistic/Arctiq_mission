
variable "local_ip" {}
variable "domain_name" {
}

variable "aws_profile" {}
variable "region_antartica" {}
variable "region_north_pole" {}

variable "vpc_antartica_cider" {}
variable "vpc_north_pole_cider" {}

variable "cidrs_antartica" {
  type = "map"
}
variable "cidrs_north_pole" {
  type = "map"
}

data "aws_availability_zones" "available" {}

variable "canada_az" {
  type = "map"
}





