provider "aws" {
    region = "us-east-1"
}

// 1. Jenkins Server
resource "aws_instance" "srv_jenkins" {
    ami = "ami-0e472ba40eb589f49"
    instance_type = "t2.micro"
    availability_zone = "us-east-1a"
    key_name = "gold"
    security_groups = [aws_security_group.sg_ports_traffic-1.name]

user_data = "${file("jenkinsroot.sh")}"

    tags = {
        "Name" = "Jenkins Server"
    }
}

// 2. Apache2 Server
resource "aws_instance" "srv_appserv" {
    ami = "ami-0e472ba40eb589f49"
    instance_type = "t2.micro"
    availability_zone = "us-east-1a"
    key_name = "gold"
    security_groups = [aws_security_group.sg_ports_traffic-2.name]

user_data = "${file("apacheroot.sh")}"

    tags = {
        "Name" = "Apache2 Server"
    }
}

// 3. Docker Server
resource "aws_instance" "srv_dockserv" {
    ami = "ami-0e472ba40eb589f49"
    instance_type = "t2.micro"
    availability_zone = "us-east-1a"
    key_name = "gold"
    security_groups = [aws_security_group.sg_ports_traffic-3.name]

user_data = "${file("dockerroot.sh")}"

    tags = {
        "Name" = "Application Docker Server"
    }
}
// 4. S3 Bucket

resource "aws_s3_bucket" "myS3bucket" {
  bucket = "www.3.myntblack.com"

  tags = {
    Name        = "www.3.myntblack.com"
  }
}

// Security Groups

resource "aws_security_group" "sg_ports_traffic-1" {
  name        = "wwwSecGrp1"
  description = "Limits Traffic"

  ingress {
    description      = "Jenkins"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["47.18.23.252/32"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["47.18.23.252/32"]

  }

  egress {
    description      = "OutBound_Traffic-Any"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    //ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "wwwSecGrp1"
  }
}

resource "aws_security_group" "sg_ports_traffic-2" {
  name        = "wwwSecGrp2"
  description = "Limits Traffic"

  ingress {
    description      = "AppServer"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["47.18.23.252/32"]
    //ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    description      = "OutBound_Traffic-Any"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    //ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "wwwSecGrp2"
  }
}


resource "aws_security_group" "sg_ports_traffic-3" {
  name        = "wwwSecGrp3"
  description = "Limits Traffic"

  ingress {
    description      = "DockerServer"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["47.18.23.252/32"]
    //ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    description      = "OutBound_Traffic-Any"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    //ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "wwwSecGrp3"
  }
}

output "Jenkins-Server" {
    value = "${aws_instance.srv_jenkins.private_ip}"
}

output "App-Server" {
    value = "${aws_instance.srv_appserv.private_ip}"
}

output "Docker-Server" {
    value = "${aws_instance.srv_dockserv.private_ip}"
}
