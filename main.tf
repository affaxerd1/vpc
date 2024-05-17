provider "aws" {
    region = "eu-west-2"
}

//create VPC, name, CIDR and Tags
resource "aws_vpc" "test_Affaxerd" {
    cidr_block = "10.0.0.0/16"   
    instance_tenancy = "default" //instance will run on shared hardware
    enable_dns_support = "true"  //enables dns resolution within the vpc
    enable_dns_hostnames = "true"  //aws will provide DNS resolution for instances within the VPC
    # enable_classiclink = "false" //disallow communication between instances in the vpc and EC2-classic instances using private Ip addresses
    tags = {
        Name = "test-Affaxerd"
    } 
  
}

//create public subnets
resource "aws_subnet" "Affaxerd-public-1" {
    vpc_id = aws_vpc.test_Affaxerd.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "eu-west-2a"
    tags = {
        Name = "test-Affaxerd-public-1"
    }

  
}

resource "aws_subnet" "Affaxerd-public-2" {
    vpc_id = aws_vpc.test_Affaxerd.id
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "eu-west-2b"
    tags = {
      Name = "Affaxerd"
    }
  
}
//create an internet gateway
resource "aws_internet_gateway" "Affaxerd-gw" {
    vpc_id = aws_vpc.test_Affaxerd.id
    tags = {
      Name = "dev"
    }
  
}

// create routes for  internet gateway
resource "aws_route_table" "affaxerd-public" {
    vpc_id = aws_vpc.test_Affaxerd.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.Affaxerd-gw.id

    }

    tags = {
      Name = "Affaxerd-public-1"
    }
  
}

//create route association with public subnets
resource "aws_route_table_association" "Affaxerd-public-1-a" {
    subnet_id = aws_subnet.Affaxerd-public-1.id
    route_table_id = aws_route_table.affaxerd-public.id

  
}

resource "aws_route_table_association" "Affaxerd-public-2-a" {
    subnet_id = aws_subnet.Affaxerd-public-2.id
    route_table_id = aws_route_table.affaxerd-public.id


}

//create EC2 instance in public subnets
resource "aws_instance" "public_inst_1" {
    ami = "ami-053a617c6207ecc7b"
    instance_type = "t2.micro"
        subnet_id = "${aws_subnet.Affaxerd-public-1.id}"
    key_name = "test-london"
    tags = {
      Name = "public_inst_1"
    }
  
}

resource "aws_instance" "public_inst_2" {
    ami = "ami-053a617c6207ecc7b"
    instance_type = "t2.micro"
    subnet_id = "${aws_subnet.Affaxerd-public-2.id}"
    key_name = "test-london"
    tags = {
      Name = "public-inst-2"
    }
  
}