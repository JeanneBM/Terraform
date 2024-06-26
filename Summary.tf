Lab 1

❯ cat main.tf 
resource "local_file" "games" {
  filename  = "/root/favorite-games"
  content  = "FIFA 21"
}

terraform init
Run a terraform init inside the configuration directory: /root/terraform-projects/HCL

terraform plan
terraform plan --> terraform apply
terraform destroy

======================================================================================================================
Lab 2

resource "local_file" "things-to-do" {
  filename     = "/root/things-to-do.txt"
  content  = "Clean my room before Christmas\nComplete the CKA Certification!"
}
resource "local_file" "more-things-to-do" {
  filename     = "/root/more-things-to-do.txt"
  content  = "Learn how to play Astronomia on the guitar!"
}

❯ cat cyberpunk.tf ps5.tf 
resource "local_file" "cyberpunk" {
  filename     = "/root/cyberpunk2077.txt"
  content  = "All I need for Christmas is Cyberpunk 2077!"
}
resource "local_file" "ps5" {
  filename     = "/root/ps5.txt"
  content  = "And a PS5!"
}


resource "local_file" "xbox" {
  filename = "/root/xbox.txt"
  content  = "Wouldn't mind an XBox either!"
}

❯ cat provider-a.tf 
terraform {
  required_providers {
    linode = {
      source = "linode/linode"
      version = "1.13.3"
    }
  }
}

❯ cat provider-b.tf 
terraform {
  required_providers {
    ansible = {
      source = "nbering/ansible"
      version = "1.0.4"
    }
  }
}

======================================================================================================================
Lab 3

resource "local_file" "jedi" {
     filename = var.jedi["filename"]
     content = var.jedi["content"]
}

======================================================================================================================

Lab 4 Variables

variables.tf:
variable "name" {
     type = string
     default = "Mark"
  
}
variable "number" {
     type = bool
     default = true
  
}
variable "distance" {
     type = number
     default = 5
  
}
variable "jedi" {
     type = map
     default = {
     filename = "/root/first-jedi"
     content = "phanius"
     }
  
}

variable "gender" {
     type = list(string)
     default = ["Male", "Female"]
}
variable "hard_drive" {
     type = map
     default = {
          slow = "HHD"
          fast = "SSD"
     }
}
variable "users" {
     type = set(string)
     default = ["tom", "jerry", "pluto", "daffy", "donald", "jerry", "chip", "dale"]

  
}

main.tf: 
resource "local_file" "jedi" {
     filename = "/root/first-jedi"
     content = "phanius"
}

cat  sample.tf 
resource "local_file" "jedi" {
        filename = var.jedi["filename"]
        content = var.jedi["content"]
}

======================================================================================================================

Lab 5 Using Variables in terraform

terraform apply -var filename=/root/tennis.txt

======================================================================================================================

Lab 6 Resource Attributes

cat main.tf 
 resource "time_static" "time_update" {
}

❯ cat main.tf 
 resource "time_static" "time_update" {
}

resource "local_file" "time" {
    filename = "/root/time.txt"
    content = "Time stamp of this file is ${time_static.time_update.id}"
}

terraform apply --auto-approve
terraform show

======================================================================================================================

Lab 7 Resource Dependencies

key.tf:

resource "tls_private_key" "pvtkey"{
    algorithm = "RSA"
    rsa_bits = 4096
}

resource "local_file" "key_details" {
    filename = "/root/key.txt"
    content = tls_private_key.pvtkey.public_key_pem
}

terraform destroy


main.tf:

resource "local_file" "whale" {
    filename = "/root/whale"
    content = "whale"
    depends_on = [ local_file.krill ]
}

resource "local_file" "krill" {
    filename = "/root/krill"
    content = "krill"
  
}


======================================================================================================================

Lab 8 Output Variables

terraform output

resource "random_pet" "my-pet" {

  length    = var.length 
}

output "pet-name" {
	
	value = random_pet.my-pet.id
	description = "Record the value of pet ID generated by the random_pet resource"
}

resource "local_file" "welcome" {
    filename = "/root/message.txt"
    content = "Welcome to Kodekloud."
}

output "welcome_message" {
	value = local_file.welcome.content
  
}

======================================================================================================================

Lab 9 Terraform State

terraform show

======================================================================================================================

Lab 10 Terraform Commands

❯ terraform graph
digraph {
        compound = "true"
        newrank = "true"
        subgraph "root" {
        }
}


terraform validate
terraform fmt //into a canonical format inside config file

terraform providers

======================================================================================================================

Lab 11  Lifecycle Rules

All the resources for the random provider can be recreated by using a map type argument called keepers. A change in the value will force the resource to be recreated.

main.tf:

resource "local_file" "file" {
    filename = var.filename
    file_permission =  var.permission
    content = random_string.string.id

}

resource "random_string" "string" {
    length = var.length
    keepers = {
        length = var.length
    }  
    lifecycle {
        create_before_destroy =  true
    }

}

terraform state show local_file.file


resource "random_pet" "super_pet" {
    length = var.length
    prefix = var.prefix
    lifecycle {
      prevent_destroy = true
    }
   
}

======================================================================================================================

Lab 12 Datasources

❯ cat main.tf 
output "os-version" {
  value = data.local_file.os.content
}
data "local_file" "os" {
  filename = "/etc/os-release"
}

======================================================================================================================

Lab 13 Count and for each

main.tf:
resource "local_sensitive_file" "name" {
    filename = "/root/user-data"
    content = "password: S3cr3tP@ssw0rd"
    count = 3

}

v2:
variable.tf:

variable "users" {
    type = list
    default = ["asia","zuzia"]
}
variable "content" {
    default = "password: S3cr3tP@ssw0rd"
    
}


main.tf:
resource "local_sensitive_file" "name" {
    filename = var.users[count.index]
    content = var.content
    count = length(var.users)

}

v3:
variable.tf:

variable "users" {
    type = list(string)
    default = [ "/root/user10", "/root/user11", "/root/user12", "/root/user10"]
}
variable "content" {
    default = "password: S3cr3tP@ssw0rd"
  
}

v4:
main.tf:

resource "local_sensitive_file" "name" {
    filename = each.value
    for_each = toset(var.users)
    content = var.content

}
variables.tf:
variable "users" {
    type = list(string)
    default = [ "/root/user10", "/root/user11", "/root/user12", "/root/user10"]
}
variable "content" {
    default = "password: S3cr3tP@ssw0rd"
  
}

======================================================================================================================

Lab 14 Version Constraints

rotation.tf:
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "> 3.45.0, !=3.46.0, < 3.48.0"
    }
  }
}

resource "google_compute_instance" "special" {
  name         = "aone"
  machine_type = "e2-micro"
  zone         = "us-west1-c"

}

tecton.tf:
terraform {
  required_providers {
    k8s = {
      source  = "hashicorp/kubernetes"
      version = "> 1.12.0, != 1.13.1, < 1.13.3 "
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 1.2.0"
    }
  }
}

======================================================================================================================

Lab 15 AWS CLI and IAM

aws --version
aws iam help
aws iam list-users help
aws --endpoint http://aws:4566 iam list-users
aws iam create-user help
aws --endpoint http://aws:4566 iam create-user --user-name mary
aws --endpoint http://aws:4566 iam list-users
/root/.aws/credentials
aws --endpoint http://aws:4566 iam attach-user-policy --user-name mary --policy-arn arn:aws:iam::aws:policy/AdministratorAccess
aws --endpoint http://aws:4566 iam create-group --group-name project-sapphire-developers

Add User to Group: 
aws --endpoint http://aws:4566 iam add-user-to-group --user-name jack --group-name project-sapphire-developers 
aws --endpoint http://aws:4566 iam add-user-to-group --user-name jill --group-name project-sapphire-developers

aws --endpoint http://aws:4566 iam attach-group-policy --group-name project-sapphire-developers  --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess

======================================================================================================================

Lab 16 IAM with Terraform

iam-user.tf:
resource "aws_iam_user" "users" {
     name = "mary"
}

provider.tf:
provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true

  endpoints {
    iam                       = "http://aws:4566"
  }
}

variables.tf:
variable "project-sapphire-users" {
     type = list(string)
     default = [ "mary", "jack", "jill", "mack", "buzz", "mater"]
}

v2:

iam-user.tf:
resource "aws_iam_user" "users" {
     name = var.project-sapphire-users[count.index]
     count = length(var.project-sapphire-users)
}

======================================================================================================================

Lab 17 S3

main.tf:
resource "aws_s3_bucket" "dc_bucket" {
  bucket = "dc_is_better_than_marvel"
  }
  
v2:
main.tf:
resource "aws_s3_object" "upload" {
  bucket = "pixar-studios-2020"
  key    = "woody.jpg"
  source = "/root/woody.jpg"
}

======================================================================================================================

Lab 18 DynamoDB

main.tf:
resource "aws_dynamodb_table" "project_sapphire_user_data" {
  name           = "userdata"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "UserId"

  attribute {
    name = "UserId"
    type = "N"
  }
}

v2
main.tf:
resource "aws_dynamodb_table" "project_sapphire_inventory" {
  name           = "inventory"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "AssetID"

  attribute {
    name = "AssetID"
    type = "N"
  }
  attribute {
    name = "AssetName"
    type = "S"
  }
  attribute {
    name = "age"
    type = "N"
  }
  attribute {
    name = "Hardware"
    type = "B"
  }
  global_secondary_index {
    name             = "AssetName"
    hash_key         = "AssetName"
    projection_type    = "ALL"

  }
  global_secondary_index {
    name             = "age"
    hash_key         = "age"
    projection_type    = "ALL"

  }
  global_secondary_index {
    name             = "Hardware"
    hash_key         = "Hardware"
    projection_type    = "ALL"

  }
}
resource "aws_dynamodb_table_item" "upload" {
  table_name = aws_dynamodb_table.project_sapphire_inventory.name
  hash_key   = aws_dynamodb_table.project_sapphire_inventory.hash_key
  item = <<EOF
 {
  "AssetID": {"N": "1"},
  "AssetName": {"S": "printer"},
  "age": {"N": "5"},
  "Hardware": {"B": "true" }
}
EOF
}

======================================================================================================================

Lab 19 Remote State

main.tf:
resource "local_file" "state" {
  filename = "/root/${var.local-state}"
  content  = "This configuration uses ${var.local-state} state"

}

v2:

main.tf:
resource "local_file" "state" {
  filename = "/root/${var.remote-state}"
  content  = "This configuration uses ${var.remote-state} state"

}

terraform.tf:
terraform {
  backend "s3" {
    key = "terraform.tfstate"
    region = "us-east-1"
    bucket = "remote-state"

  }
}

======================================================================================================================

Lab 20 Terraform State Commands

terraform state list
terraform state show local_file.classics
terraform state show local_file.top10
terraform state rm local_file.hall_of_fame
terraform state mv random_pet.super_pet_1 random_pet.ultra_pet

======================================================================================================================

Lab 21 AWS EC2 and Provisioners

main.tf:
variable "ami" {
  default = "ami-06178cf087598769c"
}

variable "instance_type" {
  default = "m5.large"
}

variable "region" {
  default = "eu-west-2"
}

resource "aws_instance" "cerberus" {
  ami           = var.ami
  instance_type = var.instance_type
}

v2:

main.tf:
variable "ami" {
  default = "ami-06178cf087598769c"
}
variable "instance_type" {
    default = "m5.large"

}
variable "region" {
  default = "eu-west-2"
}
resource "aws_instance" "cerberus" {
    ami = var.ami
    instance_type = var.instance_type

}

resource "aws_key_pair" "cerberus-key" {
    key_name = "cerberus"
    public_key = file(".ssh/cerberus.pub")
}

resource "aws_instance" "cerberus" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = "cerberus"
}

v3:

main.tf:
variable "ami" {
  default = "ami-06178cf087598769c"
}
variable "instance_type" {
    default = "m5.large"

}
variable "region" {
  default = "eu-west-2"
}
resource "aws_instance" "cerberus" {
    ami = var.ami
    instance_type = var.instance_type
    key_name  = "cerberus"
    user_data = file("./install-nginx.sh")

}
resource "aws_key_pair" "cerberus-key" {
    key_name = "cerberus"
    public_key = file(".ssh/cerberus.pub")
}

v4:

main.tf:
resource "aws_instance" "cerberus" {
  ami           = var.ami
  instance_type = var.instance_type
  user_data     = file("./install-nginx.sh")

}
resource "aws_key_pair" "cerberus-key" {
  key_name   = "cerberus"
  public_key = file(".ssh/cerberus.pub")
}
resource "aws_eip" "eip" {
  vpc      = true
  instance = aws_instance.cerberus.id
  provisioner "local-exec" {
    command = "echo ${aws_eip.eip.public_dns} >> /root/cerberus_public_dns.txt"
  }

}
variable "ami" {
  default = "ami-06178cf087598769c"
}
variable "instance_type" {
  default = "m5.large"

}
variable "region" {
  default = "eu-west-2"
}

======================================================================================================================

Lab 22 Taint and Debugging

export TF_LOG=ERROR; export TF_LOG_PATH=/tmp/ProjectA.log; terraform init; terraform apply
terraform untaint aws_instance.ProjectB

======================================================================================================================

Lab 23 Terraform Import

terraform show
terraform state list
terraform output
aws ec2 create-key-pair --endpoint http://aws:4566 --key-name jade --query 'KeyMaterial' --output text > /root/terraform-projects/project-jade/jade.pem
aws ec2 describe-instances --endpoint http://aws:4566
aws ec2 describe-instances --endpoint http://aws:4566  --filters "Name=image-id,Values=ami-082b3eca746b12a89" | jq -r '.Reservations[].Instances[].InstanceId'

jade-mw.tf:
resource "aws_instance" "ruby" {
  ami           = var.ami
  instance_type = var.instance_type
  for_each      = var.name
  key_name      = var.key_name
  tags = {
    Name = each.value
  }
}
output "instances" {
 value = aws_instance.ruby
}
resource "aws_instance" "jade-mw" {

}

terraform import aws_instance.jade-mw id-of-the-resource
terraform show -json | jq '.values.root_module.resources[] | select(.type == "aws_instance" and .name == "jade-mw")'
aws ec2 describe-instances --filters "Name=tag:Name,Values=jade-mw" --query "Reservations[*].Instances[*].[ImageId, InstanceType, KeyName, Tags]" --endpoint http://aws:4566

======================================================================================================================

Lab 24 Terraform Modules

registry.terraform.io

main.tf:
module "iam_iam-user" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "5.28.0"
  name = "asiula"
}

======================================================================================================================

Lab 25 Functions and Conditional Expressions

echo "floor(10.9)" | terraform console 
echo 'title("user-generated password file")' | terraform console

main.tf:
resource "aws_iam_user" "cloud" {
     name = split(":",var.cloud_users)[count.index]
     count = length(split(":",var.cloud_users))

}

echo 'aws_iam_user.cloud[6].name' | terraform console
echo "index(var.sf,\"oni\")" | terraform console

main.tf:
resource "aws_iam_user" "cloud" {
     name = split(":",var.cloud_users)[count.index]
     count = length(split(":",var.cloud_users))

}
resource "aws_s3_bucket" "sonic_media" {
     bucket = var.bucket

}
resource "aws_s3_object" "upload_sonic_media" {
     bucket = aws_s3_bucket.sonic_media.id
     key =  substr(each.value, 7, 20)
     source = each.value
     for_each = var.media 

}

terraform init; echo 'var.small' | terraform console

v2:

main.tf:
resource "aws_instance" "mario_servers" {
     ami = var.ami
     instance_type = var.name == "tiny" ? var.small : var.large
     tags = {
          Name = var.name

     }

}

======================================================================================================================

Lab 26 Terraform Workspaces

terraform workspace list
terraform workspace new us-payroll
terraform workspace new uk-payroll
terraform workspace new india-payroll
terraform workspace select us-payroll

main.tf:
module "payroll_app" {
  source = "/root/terraform-projects/modules/payroll-app"
  app_region = lookup(var.region, terraform.workspace)
  ami        = lookup(var.ami, terraform.workspace)
}

terraform workspace select us-payroll; terraform apply
terraform workspace select uk-payroll; terraform apply
terraform workspace select india-payroll; terraform apply

======================================================================================================================
