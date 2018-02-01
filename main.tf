#
# DO NOT DELETE THESE LINES!
#
# Your AMI ID is:
#
#     ami-66506c1c
#
# Your subnet ID is:
#
#     subnet-ce92e593
#
# Your security group ID is:
#
#     sg-3ee83749
#
# Your Identity is:
#
#     customer-training-haddock
#

terraform {
  backend "atlas" {
    name = "gjustice/training"
  }
}

#module "example" {
#  source = "./example-module"
#  command = "echo 'Hey World'"
#}

variable "num_webs" {
  default = "2"
}

variable "aws_access_key" {
  type = "string"
}

variable "aws_secret_key" {}

variable "aws_region" {
  type    = "string"
  default = "us-east-1"
}

provider "aws" {
  ##  region     = "us-east-1"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

resource "aws_instance" "web" {
  count                  = "2"
  ami                    = "ami-66506c1c"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-ce92e593"
  vpc_security_group_ids = ["sg-3ee83749"]

  tags {
    "Identity" = "customer-training-haddock"
    "Flavour"  = "foo"
    "Colour"   = "bar"
    "Name"     = "web ${count.index+1}/${var.num_webs}"
  }
}

output "public_ip" {
  value = ["${aws_instance.web.*.public_ip}"]
}

output "public_dns" {
  value = "${aws_instance.web.1.public_dns}"
}
