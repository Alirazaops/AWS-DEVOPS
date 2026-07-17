resource "aws_vpc" "prd_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
      name = "prd_vpc"
    }
  
}

resource "aws_subnet" "prd_subnet_db_1" {
    vpc_id = aws_vpc.prd_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-west-2a"
    tags = {
      name = "prd_subnet_db_1"
    }
  
}

resource "aws_subnet" "prd_subnet_db_2" {
    vpc_id = aws_vpc.prd_vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-west-2b"
    tags = {
      name = "prd_subnet_db_2"
    }
  
}

resource "aws_security_group" "prd_sg" {
    name = "prd_sg"
    description = "aws_security_group for rds DB"
    vpc_id = aws_vpc.prd_vpc.id
    
    ingress{
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    } 
    ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress{
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
  
}

resource "aws_db_subnet_group" "aws_db_subnet_group" {
    name = "db_subnet_group"
    subnet_ids = [aws_subnet.prd_subnet_db_1.id, aws_subnet.prd_subnet_db_2.id]
    tags = {
      name = "DB Subnet Group"
    }
  
}

resource "aws_db_instance" "mysql-db" {
    identifier = "mysql-dbinstance"
    instance_class = "db.t4g.micro"
    engine = "mysql"
    engine_version = "8.0"
    allocated_storage = 20
    username = "admin"
    manage_master_user_password = true
    db_subnet_group_name = aws_db_subnet_group.aws_db_subnet_group.name
    vpc_security_group_ids = [aws_security_group.prd_sg.id]
    skip_final_snapshot     = true
    maintenance_window      = "sun:05:00-sun:09:00"
    backup_retention_period  = 7
  
}