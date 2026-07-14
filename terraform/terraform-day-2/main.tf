resource "aws_instance" "prd" {
    ami = var.ami_id
    instance_type = var.instance_type
    tags = {
        Name = var.tags
    }

}