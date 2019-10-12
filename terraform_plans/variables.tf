

#EC2 vars

variable "dev_instance_type" {}
variable "dev_ami_antartica" {}
variable "dev_ami_north_pole" {}
variable "penguin_public_key_path" {}
variable "bear_public_key_path" {}

# Key Pair

variable "key_name" {}
variable "key_name_" {}




#DB VARS
variable "db_instance_class" {}
variable "dbname1" {}
variable "dbname2" {}
variable "dbuser" {}
variable "dbpassword" {}
#AWS vars
variable "local_ip" {}
variable "domain_name" {}
variable "aws_profile" {}
#REGIONS
variable "region_antartica" {}
variable "region_north_pole" {}
variable "vpc_antartica_cider" {}
variable "vpc_north_pole_cider" {}
# SUBNETS
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


#ELB
variable elb_healthy_threshold {}
variable elb_unhealthy_threshold {}
variable elb_timeout {}
variable elb_interval {}

# AUTOSCALING
variable "asg_max" {}
variable "asg_min" {}
variable "asg_grace" {}
variable "asg_hct" {}
variable "asg_cap" {}
# Lunch Configuration
variable "lc_instance_type" {}

