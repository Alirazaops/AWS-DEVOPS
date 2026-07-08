resource "aws_vpc" "prd" {
  cidr_block = var.cidr_block
  tags = {
    Name = var.tag
  }
}

resource "aws_vpc" "dev" {
    cidr_block = var.cidr_block_prd_2
    tags = {
        Name = var.tag_prd_2
    }
}

resource "aws_subnet" "prd_sub" {
  vpc_id = aws_vpc.prd.id
  cidr_block = var.cidr_block_subnet
  tags = {
    Name = var.cidr_block_subnet_tag
  }
}