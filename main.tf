provider "aws" {
	region = "us-east-2"
}

variable "server_port" {
	description = "Das ist der freizuschaltende Netzwerkport"
	#type = "string"
	default	= 8080
}

data "aws_availability_zones" "all" {}


resource "aws_launch_configuration" "example" {
	image_id	= "ami-5e8bb23b"
	instance_type	= "t2.micro"
	security_groups	= ["${aws_security_group.instance.id}"]

	user_data	=	<<-EOF
				#!/bin/bash
				echo "Hallo , so schnell gehts mit Amazon..." > index.html
				nohup busybox httpd -f -p "${var.server_port}" & 
				EOF
	lifecycle {
		create_before_destroy = true
	}

}

resource "aws_security_group" "instance" {
	name 	= "terraform-example-instance"

	ingress {
		from_port	= "${var.server_port}"
		to_port		= "${var.server_port}"
		protocol	= "tcp"
		cidr_blocks	= ["0.0.0.0/0"]
	}
	lifecycle {
		create_before_destroy = true
	}
}

resource "aws_autoscaling_group" "example" {
	launch_configuration = "${aws_launch_configuration.example.id}"
	availability_zones = ["${data.aws_availability_zones.all.names}"]

	min_size = 2
	max_size = 10
	
	tag {
		key		= "Name"
		value		= "terraform-asg-example"
		propagate_at_launch = true
	}
}


# output "public_ip" {
#  value = "${aws_autoscaling_group.example.public_ip}"
#}
