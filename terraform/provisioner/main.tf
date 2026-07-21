# Key

resource "aws_key_pair" "prd_key" {
    key_name = "EC2-Server"
    public_key = file("~/.ssh/id_ed25519.pub")
  
}

resource "aws_vpc" "prd_vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support   = true
    enable_dns_hostnames = true
    tags = {
      name = "prd_vpc"
    }
  
}
resource "aws_subnet" "aws-subnet-1" {
    vpc_id = aws_vpc.prd_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-west-2a"
    map_public_ip_on_launch = true
     tags = {
       name = "aws-subnet-1"
     }

  
}

resource "aws_internet_gateway" "prd_igw" {
    vpc_id = aws_vpc.prd_vpc.id
  
}

resource "aws_route_table" "aws_route_table_prd" {
    vpc_id = aws_vpc.prd_vpc.id

    route {
        cidr_block ="0.0.0.0/0"
        gateway_id = aws_internet_gateway.prd_igw.id
    }
  
}

resource "aws_route_table_association" "rt_associ_prd" {
    
    subnet_id = aws_subnet.aws-subnet-1.id
    route_table_id = aws_route_table.aws_route_table_prd.id
  
}

resource "aws_security_group" "prd_sg" {
  name = "prd_sg"
  vpc_id = aws_vpc.prd_vpc.id

  ingress {
    description = "Allow HTTP"
    from_port  = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress   {
    description = "Allow SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress   {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#EC2 Instance  (Ubuntu)
resource "aws_instance" "prd_ec2" {
  ami = "ami-071d641d6d46d34f8"
  instance_type =  "t2.micro"
  subnet_id = aws_subnet.aws-subnet-1.id
  vpc_security_group_ids = [aws_security_group.prd_sg.id]
  associate_public_ip_address = true
  key_name = aws_key_pair.prd_key.key_name

  tags = {
    name = "EC2-Server"
  }

  connection {
    type = "ssh"
    user = "ec2-user"
    host = self.public_ip
    private_key = file("~/.ssh/id_ed25519")
    timeout = "5m"
  }

  provisioner "file" {
    source = "file10"
    destination = "/home/ec2-user/file10"   #"/home/ubuntu/file10"
    
  }


  provisioner "local-exec" {
    command = "touch file500"
    
  }

  provisioner "remote-exec" {
    inline = [ 
        "touch /home/ec2-user/file200",
        "echo 'This is terraform' >> /home/ec2-user/file200"
     ]
    
  }
}

# resource "null_resource" "run_script" {
#   provisioner "remote-exec" {
#     connection {
#       host        = aws_instance.server.public_ip
#       user        = "ubuntu"
#       private_key = file("~/.ssh/id_ed25519")
#     }
#      provisioner "file" {
#     source      = "file10"
#     destination = "/home/ubuntu/dev.sh" #destination path on the remote instance copy the file10 from local to remote instance with the name file10
#   }


#     inline = [
#       "echo 'hello from veera Nareshit' >> /home/ubuntu/file200",
      
#         #"bash /home/ubuntu/dev.sh" # Assuming test.sh is already on the instance 
#     ]
#   }

#   triggers = {
#     always_run = "${timestamp()}" # This will ensure the provisioner runs every time you apply, as the timestamp will always change.
#   }
# #   triggers = {
# #   script_hash = filemd5("dev.sh") # Rerun only if script changes
# # }
# }


#Solution-2 to Re-Run the Provisioner
# Use terraform taint to manually mark the resource for recreation:
# terraform taint aws_instance.server
# terraform apply