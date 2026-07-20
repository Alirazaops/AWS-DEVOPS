module "dev" {
    source = "../module-ec2"
    ami = var.ami
    instance_type = var.instance_type
    tags = var.tags

    # Module Variabe = Local Variable 
  
}