provider "aws" {
	region = "us-east-2"
}

resource "aws_instance" "myexample" {
	ami	= "ami-5e8bb23b"
	instance_type = "t2.micro"
	tags {
		Name = "terraform-example"
	}
}
