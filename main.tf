/*
 * Module: tf_aws_sg_elb_lc_asg
 *
 * This template creates the following resources
 *    - 2 security groups
 *      - 1 Ingress -> allow all traffic in on port 80; Outbound -> only to security group 2
 *      - 1 Ingress -> from ELB security group on port 80; Inbound on port 22 from anywhere; Outbound -> wide open
 *    - A load balancer
 *    - A launch configuration
 *    - An auto-scale group
 *
 */

resource "aws_security_group" "sg_elb" {
  name        = "${var.sg_elb_name}"
  vpc_id      = "${var.vpc_id}"

  # inbound HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound only to items with the sg_instance security group
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = ["${aws_security_group.sg_instance.id}"]
  }
 }

resource "aws_security_group" "sg_instance" {
  name          = "${var.sg_instance_name}"
  vpc_id        = "${var.vpc_id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
 }

resource "aws_elb" "elb" {
  name             = "${var.elb_name}"
  availability_zones = ["${split(",", var.availability_zones)}"]
  security_groups  = ["${aws_security_group.sg_elb.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/healthcheck"
    interval = 20
  }
}

resource "aws_launch_configuration" "launch_config" {
  name = "${var.lc_name}"
  image_id = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_name}"
  security_groups = ["${aws_security_group.sg_instance.id}"]
}

resource "aws_autoscaling_group" "main_asg" {
  # We want this to explicitly depend on the launch config above
  depends_on = ["aws_launch_configuration.launch_config", "aws_elb.elb"]

  name = "${var.asg_name}"

  # The chosen availability zones *must* match the AZs the VPC subnets are tied to.
  availability_zones = ["${split(",", var.availability_zones)}"]
  vpc_zone_identifier = ["${split(",", var.vpc_zone_subnets)}"]

  # Uses the ID from the launch config created above
  launch_configuration = "${aws_launch_configuration.launch_config.id}"

  max_size = "${var.asg_number_of_instances}"
  min_size = "${var.asg_minimum_number_of_instances}"
  desired_capacity = "${var.asg_number_of_instances}"

  health_check_grace_period = "${var.health_check_grace_period}"
  health_check_type = "${var.health_check_type}"

  load_balancers = ["${var.elb_name}"]
}
