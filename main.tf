this is test file
provider "aws" {
  region = "ap-south-1"
}

# Create Vpc 
resource "aws_vpc" "main_test" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "test"
  }
}

# Create Subnet group
resource "aws_subnet" "main_subnet-1" {
  vpc_id     = aws_vpc.main_test.id
  map_public_ip_on_launch = true
  availability_zone = "ap-south-1a"
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "subnet-1"
  }
}

resource "aws_subnet" "main_subnet-2" {
  vpc_id     = aws_vpc.main_test.id
  map_public_ip_on_launch = true
  availability_zone = "ap-south-1b"
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "subnet-2"
  }
}

resource "aws_subnet" "main_subnet-3" {
  vpc_id     = aws_vpc.main_test.id
  map_public_ip_on_launch = true
  availability_zone = "ap-south-1c"
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "subnet-3"
  }
}

resource "aws_subnet" "main_subnet-4" {
  vpc_id     = aws_vpc.main_test.id
  map_public_ip_on_launch = true
  availability_zone = "ap-south-1a"
  cidr_block = "10.0.4.0/24"

  tags = {
    Name = "subnet-4"
  }
}


resource "aws_internet_gateway" "main_test" {
  vpc_id = aws_vpc.main_test.id

  tags = {
    Name = "internet-gateway"
  }
}

resource "aws_route_table" "main_route-public" {
  vpc_id = aws_vpc.main_test.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_test.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "subnet1" {
  subnet_id      = aws_subnet.main_subnet-1.id
  route_table_id = aws_route_table.main_route-public.id
}


resource "aws_route_table_association" "subnet2" {
  subnet_id      = aws_subnet.main_subnet-2.id
  route_table_id = aws_route_table.main_route-public.id
}

resource "aws_route_table" "main_route-private" {
  vpc_id = aws_vpc.main_test.id

   tags = {
    Name = "private-route-table"
  }
}

resource "aws_route_table_association" "subnet3" {
  subnet_id      = aws_subnet.main_subnet-3.id
  route_table_id = aws_route_table.main_route-private.id
}


resource "aws_route_table_association" "subnet4" {
  subnet_id      = aws_subnet.main_subnet-4.id
  route_table_id = aws_route_table.main_route-private.id
}
#Security group creation
resource "aws_security_group" "main_sg-1" {
  name = "main_sg-1"
  vpc_id = aws_vpc.main_test.id

  tags = {
    Name = "main_sg-1"
  }
}
resource "aws_vpc_security_group_ingress_rule" "main_sg_ipv4" {
  security_group_id = aws_security_group.main_sg-1.id
  cidr_ipv4 = aws_subnet.main_subnet-1.cidr_block
  from_port = 443
  ip_protocol = "tcp"
  to_port = 443
  
}
resource "aws_vpc_security_group_ingress_rule" "main_sg_1" {
  security_group_id = aws_security_group.main_sg-1.id
  cidr_ipv4 = aws_subnet.main_subnet-2.cidr_block
  from_port = 444
  ip_protocol = "tcp"
  to_port = 444
  
}
resource "aws_vpc_security_group_ingress_rule" "main_sg-2" {
  security_group_id = aws_security_group.main_sg-1.id
  cidr_ipv4 = aws_subnet.main_subnet-3.cidr_block
  from_port = 8080
  ip_protocol = "tcp"
  to_port = 8080
  
}
resource "aws_vpc_security_group_egress_rule" "main-outbount" {
  security_group_id = aws_security_group.main_sg-1.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_instance" "TestInstance-1" {
  ami = "ami-05c179eced2eb9b5b"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.main_subnet-1.id
  associate_public_ip_address = true
  security_groups = [aws_security_group.main_sg-1.id]
  tags = {
    Name = "MyfirstInstance-1"
    Manageby = "Terraform"
  }
  }