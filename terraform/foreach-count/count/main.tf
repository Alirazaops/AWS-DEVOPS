resource "aws_instance" "prd_instance" {
    ami = "ami-0b826bb6d96d2afe4"
    instance_type = "t2.small"
    count = length(var.tags)
    tags = {
        name = var.tags[count.index]
    }
  
}