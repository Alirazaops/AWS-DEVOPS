variable "cidr_block" {
    description = "The CIDR block for the VPC"
    type =  string
    default = ""
  
}

variable "tag" {
    description = "The tag for the vpc"
    type = string
    default = ""
}

variable "cidr_block_prd_2" {
    description = "The CIDR block for the VPC"
    type =  string
    default = ""
  
}

variable "tag_prd_2" {
    description ="The tag for VPC dev"
    type = string
    default = "" 

}

variable "cidr_block_subnet" {
    description = "The cidr block for the subnet"
    type = string
    default = ""
}

variable "cidr_block_subnet_tag" {
    type = string
    default = "My_Subnet"
  
}