variable "sg_elb_name" {
  default = "sgelb"
}
variable "sg_instance_name" {
  default = "sginstance"
}
variable "vpc_id" {
  default = "vpc-32109d57"
}
variable "elb_name" {
  default = "myelb"
}
variable "lc_name" {
  default = "examplelc"
}
variable "ami_id" {
  default = "ami-fce3c696"
}
variable "instance_type" {
  default = "t2.small"
}
variable "iam_instance_profile" {
  default = "arn:aws:iam::197794640034:instance-profile/instanceRole"
}
variable "key_name" {
  default = "masmith_ec2"
}
variable "asg_name" {
  default = "my-custom-asg"
}
variable "asg_number_of_instances" {
  default = 2
}
variable "asg_minimum_number_of_instances" {
  default = 1
}
variable "health_check_type" {
  default = "ELB"
}
variable "availability_zones" {
  default = "us-east-1a,us-east-1b"
}
variable "vpc_zone_subnets" {
  default = "subnet-70ed015b,subnet-dd64c6aa"
}
