# creation of vpc custom network configure
resource "aws_vpc" "prd_vpc" {
  cidr_block = "10.0.0.0/16"
    tags = {
    Name = "prd_vpc"        
}
}

resource "aws_subnet" "prd_subnet" {
    vpc_id            = aws_vpc.prd_vpc.id
    cidr_block        = "10.0.1.0/24"
    tags = {
        Name = "prd_subnet"
    }
}

resource "aws_internet_gateway" "prd_igw" {
    vpc_id = aws_vpc.prd_vpc.id
    tags = {
        Name = "prd_igw"
    }
}

resource "aws_route_table" "prd_route_table" {
    vpc_id = aws_vpc.prd_vpc.id
    tags = {
        Name = "prd_route_table"
    }
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.prd_igw.id
    }
}

#creation of route table association with subnet for custom network configuration

resource "aws_route_table_association" "prd_subnet_association" {
    subnet_id      = aws_subnet.prd_subnet.id
    route_table_id = aws_route_table.prd_route_table.id
}

resource "aws_security_group" "prd_sg" {
    name        = "prd_sg"
    description = "Security group for prd_vpc"
    vpc_id      = aws_vpc.prd_vpc.id

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

#creation of ec2 instance in custom network configuration
resource "aws_instance" "prd_instance" {
    ami           = "ami-0fd6b4bfb40773c2d" # Replace with a valid AMI ID for your region
    instance_type = "t2.micro"
    subnet_id     = aws_subnet.prd_subnet.id
    vpc_security_group_ids = [aws_security_group.prd_sg.id]
    associate_public_ip_address = true
    tags = {
        Name = "prd_instance"
    }
}



#creation of ec2 private instance in custom network configuration 

resource "aws_subnet" "prd_private_subnet" {
    vpc_id            = aws_vpc.prd_vpc.id
    cidr_block        = "10.0.2.0/24"
    tags = {
        Name = "prd_private_subnet"
    }
}



resource "aws_eip" "prd_eip" {
  domain = "vpc"
  tags = {
    Name = "prd_eip"
  }
}

resource "aws_nat_gateway" "prd_nat_gw" {
  allocation_id = aws_eip.prd_eip.id
  subnet_id     = aws_subnet.prd_private_subnet.id
  tags = {
    Name = "prd_nat_gw"
  }
}

resource "aws_route_table" "prd_private_route_table" {
    vpc_id = aws_vpc.prd_vpc.id
    tags = {
        Name = "prd_private_route_table"
    }
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.prd_nat_gw.id
    }
}

resource "aws_instance" "prd_private_instance" {
    ami           = "ami-0fd6b4bfb40773c2d" # Replace with a valid AMI ID for your region
    instance_type = "t2.micro"
    subnet_id     = aws_subnet.prd_private_subnet.id
    vpc_security_group_ids = [aws_security_group.prd_sg.id]
    associate_public_ip_address = false
    tags = {
        Name = "prd_private_instance"
    }
}