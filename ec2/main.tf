terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 4.16"
        }
    }

    required_version = ">= 1.2.0"
}

provider "aws" {
    region = "${var.aws_region}"
}

resource "aws_instance" "windows_server" {
    ami           = "${var.ami_windows}"
    instance_type = "${var.windows_instance_type}"

    tags = {
        Name = "${var.instance_name}"
    }
}

data "aws_security_group" "selected_sg" {
  id = "${var.sg_id}"
}

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = "${data.aws_security_group.selected_sg.id}"
  network_interface_id = "${aws_instance.windows_server.primary_network_interface_id}"
}
