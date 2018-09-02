provider "aws" {
	region = "us-east-2"
}

variable "server_port" {
	description = "Das ist der freizuschaltende Netzwerkport"
	#type = "string"
	default	= 8080
}

resource "aws_instance" "example" {
	ami	= "ami-5e8bb23b"
	instance_type	= "t2.micro"
	vpc_security_group_ids	= ["${aws_security_group.instance.id}"]

	user_data	=	<<-EOF
				#!/bin/bash
				echo "Hallo Welt, so schnell gehts mit Amazon..." > index.html
				nohup busybox httpd -f -p "${var.server_port}" & 
				EOF

	tags {
		Name	= "terraform-example-showcase"
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
}

output "public_ip" {
  value = "${aws_instance.example.public_ip}"
}
