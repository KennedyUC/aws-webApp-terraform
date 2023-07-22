env                 = "dev"
project_name        = "devops_task"
vpc_cidr            = "10.0.0.0/16"
enable_vpc_dns      = true
subnet_count        = 2
subnet_bits         = 8

ec2_ami_id          = "ami-061dbd1209944525c"
ec2_instance_type   = "t2.medium"
min_instance_count  = 2
max_instance_count  = 4

db_storage_size     = 20
db_storage_type     = "gp2"
db_engine_type      = "postgres"
db_engine_version   = "14.8"
db_instance_class   = "db.t3.micro"
db_name             = "postgres"

aws_region          = "us-east-1"