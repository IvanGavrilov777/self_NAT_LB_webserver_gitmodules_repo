terraform {
  cloud {
    organization = "ivan-testing"
    workspaces {
      name = "self_NAT_LB_webserver_localmodules"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.53.0"
    }
  }
}

#Provider configurations
provider "aws" {
  region = "us-west-2"
}

module "vpc" {
source = "https://github.com/IvanGavrilov777/refactor-vpc"
}

module "security" {
source = "https://github.com/IvanGavrilov777/refactor-security"
vpc_id = module.vpc.vpc_id
}

module "vm" {
source = "https://github.com/IvanGavrilov777/refactor-vm"
VM_sec_group = module.security.VM_sec_group
private_subnet_id = module.vpc.private_subnet_id
}

module "elb" {
source = "https://github.com/IvanGavrilov777/refactor-elb"
public_subnet_id = module.vpc.public_subnet_id
elb_security_group = module.security.elb_security_group
aws_instance_web_id = module.vm.aws_instance_web_id
}

#The output will give an ELB DNS to be accessed from browser
output "address" {
  value = module.elb.elb_dns
}
