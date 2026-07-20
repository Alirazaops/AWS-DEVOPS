variable "ami" {
    description = "The AMI ID to EC2 instance"
    type = string
    default = ""
  
}

variable "instance_type" {
    description = "The Instance Type to EC2 instance"
    type = string
    default = ""
  
}

variable "tags" {
    description = "The tags for EC2 instance"
    type = string
    default = ""
  
}