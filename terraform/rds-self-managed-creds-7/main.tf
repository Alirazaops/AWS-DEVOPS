#RDS self managed credential :- 

#Creation a VPC

resource "aws_vpc" "prd_vpc" {
	cidr_block = "10.0.0.0/16"
    enable_dns_support   = true
    enable_dns_hostnames = true
	tags = {
		Name = " prd_vpc"
	}
} 


#Creation Two Private Subnets

resource "aws_subnet" "prd_subnet_db_1" {
	vpc_id = aws_vpc.prd_vpc.id
	cidr_block	= "10.0.1.0/24"
	availability_zone = "us-west-2a"
	tags  = {
		Name  = "prd_subnet_db_1"
	}

}

resource "aws_subnet" "prd_subnet_db_2" {
	vpc_id = aws_vpc.prd_vpc.id
	cidr_block	= "10.0.2.0/24"
	availability_zone = "us-west-2b"	
	tags  = {
		Name  = "prd_subnet_db_2"
	}

}

#Creation subnet group 

resource "aws_db_subnet_group" "aws_db_subnet_group_db" {
	name = "my-db-subnet-groups"
	subnet_ids = [aws_subnet.prd_subnet_db_1.id, aws_subnet.prd_subnet_db_2.id]
	tags = {
		Name = "DB Subnet Group"
	}
}


# Creation security  group 
resource "aws_security_group" "prd_sg" {
	name = "prd_sg"
	description  = "aws security group for vpc_prd"
	vpc_id = aws_vpc.prd_vpc.id
	 ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
     ingress {
        from_port   = 3306
        to_port     = 3306
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

#Creation of Private RDS instance with self managed credentials

resource "aws_db_instance" "mysql-db" {
    identifier              = "mysql-dbinstance"
    engine                  = "mysql"
    engine_version          = "8.0"
    instance_class          = "db.t4g.micro"
    allocated_storage       = 20
    username                = "admin"
    password                = "Cloud#123" #Self managed password
    #manage_master_user_password = true #enable password management by AWS secrets Manager 
    db_subnet_group_name    = aws_db_subnet_group.aws_db_subnet_group_db.name
    vpc_security_group_ids  = [aws_security_group.prd_sg.id]
    skip_final_snapshot     = true
    maintenance_window      = "sun:05:00-sun:09:00"
    backup_retention_period  = 7

}

#Creation RDS Replica 

resource "aws_db_instance" "replica" {
    identifier      = "mysql-replica"
    instance_class = "db.t4g.micro"
    replicate_source_db = aws_db_instance.mysql-db.identifier

}





#terraform target command is used to apply the changes to specific resources in the configuration. 
#It allows you to selectively apply changes to a subset of resources, rather than applying changes to all resources in the configuration. 
#This can be useful when you want to make changes to a specific resource without affecting other resources in the configuration.

#ex: tf plan --target=aws_security_group.prd_sg
#tf apply --target=aws_vpc.dev_vpc --target=aws_subnet.dev_subnet #if multiple resosurce are to be applied then use --target for each resource