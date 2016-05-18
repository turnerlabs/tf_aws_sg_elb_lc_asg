/*
 * Module: tf_aws_sg_elb_lc_asg
*/

 #
 # Security Group Variables
 #

variable "sg_elb_name" {
  description = "The name used for the security group applied to the load balancer"
}
variable "sg_instance_name" {
  description = "The name used for the security group applied to all the provisioned instances"
}
variable "vpc_id" {
  description = "The VPC id that all the infrastructure is applied to"
}

#
# ELB Variables
#

variable "elb_name" {
  description = "The name used for the load balancer"
}
variable "elb_listener_lb_port" {
  description = "The port the ELB will listen to incoming traffic on"
}
variable "elb_listener_instance_port" {
  description = "The port the elb will forward traffic to"
}
variable "elb_health_check_healthy_threshold" {
  description = "The number of checks before the instance is declared healthy"
  default = "10"
}
variable "elb_health_check_unhealthy_threshold" {
  description = "The number of checks before the instance is declared unhealthy"
  default = "2"
}
variable "elb_health_check_timeout" {
  description = "The length of time before the check times out"
  default = "5"
}
variable "elb_health_check_target" {
  description = "The target of the heath check. usually something like HTTP:<instance_port>/healthcheck"
}
variable "elb_health_check_interval" {
  description = "The interval between health checks"
  default = "30"
}
variable "elb_internal_bool" {
  description = "If the ELB is going to be internal or not"
  default = "true"
}

#
# Launch Configuration Variables
#
variable "lc_name" {
  description = "The name used for the launch configuration"
}
variable "ami_id" {
  description = "The AMI to use with the launch configuration"
}
variable "instance_type" {
  description = "The instance type.  ex. t2.small, m1.medium, etc."
}
variable "key_name" {
  description = "The SSH public key name (in EC2 key-pairs) to be injected into instances"
}
variable "user_data" {
  description = "The path to a file with the user_data for the instances"
}
variable "associate_public_ip_address" {
  description = "This allows an instance to be externally accessible"
  default = false
}

#
# Auto-Scaling Group
#
variable "asg_name" {
  description = "The name used for the auto scale group"
}

/* We use this to populate the following ASG settings
 * - max_size
 * - desired_capacity
 */
variable "asg_number_of_instances" {
  description = "The number of instances we want in the ASG"
}

/*
 * Can be set to 0 if you never want the ASG to replace failed instances
 */
variable "asg_minimum_number_of_instances" {
  description = "The minimum number of instances the ASG should maintain"
  default = 1
}
variable "health_check_grace_period" {
  description = "Number of seconds for a health check to time out"
  default = 300
}
/*
 * Types available are:
 *   - ELB
 *   - EC2
 *
 *   @see-also: http://docs.aws.amazon.com/cli/latest/reference/autoscaling/create-auto-scaling-group.html#options
 */
variable "health_check_type" {
  description = "The health check used by the ASG to determine health"
  default = "ELB"
}

/*
 * A string list of AZs, ex:
 * "us-east-1a,us-east-1c,us-east-1e"
 */
variable "availability_zones" {
  description = "A comma seperated list string of AZs the ASG will be associated with"
}

/*
 * A string list of VPC subnet IDs, ex:
 * "subnet-d2t4sad,subnet-434ladkn"
 */
variable "vpc_zone_subnets" {
  description = "A comma seperated list string of VPC subnets to associate with ASG, should correspond with var.availability_zones zones"
}

/*
 * A string list of termination policiess, ex:
 * "OldestLaunchConfiguration,OldestInstance"
 */
variable "termination_policy" {
  description = "A comma separated list of termination policy(ies) used to terminate instances"
  default = "OldestLaunchConfiguration,OldestInstance"
}

variable "instance_name" {
  description = "Name to be applied to launched instances"
}
