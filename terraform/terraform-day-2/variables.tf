variable "ami_id" {
  description = "The AMI ID to use for the instance"
  type        = string
  default     = "ami-002192a70217ac181"
}

variable "instance_type" {
  description = "The instance type to use for the instance"
  type        = string
  default     = "t2.micro"
}

variable "tags" {
  description = "The tags to applry to the instance"
  type = string
  default = "my-instance"
}