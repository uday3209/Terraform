variable "security_group_id" {
  default = "sg-0946034553051ebe6"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


data "aws_security_group" "selected" {
  id = var.security_group_id
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCV0A5kuvj37LnCGRWS+
d9sDjvyTrOnzCTM25hVB/Dx4l2l2h4NIDtS5sA+Eu1F1NFu941AmTtbgCVOm2/Ax2pSUC820N
qxXHPdMq5KMj7ZNSTqxN19RaGNC1h2mj2i4OPwQJcKQijY0U+xkmSOX/poTsEgY09O2OqTFRBADqVKwa58M7Rg
041m6CVHXowNeUXEbHDDNVxhQq7BCvN0t7lAvjofikfOHQlMlmsjumnFHFXqXnoR7SzYC8UYJ96W1g67tA7m4gloqoT
BqrjHUuOFVp60gXoctIsgRbvuA0LuaNj36e8rLHdiQDNcFxLae2geiXh1syRbVsDALDoPQW9WEywTLAFl4iDrjBygqgUwp3D
5M7lkeagEuXg1NVXl3+ufqEoJ51YeTsirYheHG2UfSEqc5k4K9ppnrRLW4MQ33Z0ZtHHXDxXgg0QFJscdqt5XIVG0iBIeSzeSusvYGFbKI
sY4ArjgZLvLMUrLYc65sDbLebLtt8FiPfN+WHD2sj8= root@tf-server"
}

resource "aws_instance" "sample" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  key_name      = "deployer-key"

  tags = {
    Name = "Sample-Server"
  }

  vpc_security_group_ids = [data.aws_security_group.selected.id]
}
