# ==============================================================================
# 1. TERRAFORM CONSTRAINTS & COMPILATION REQUIREMENTS
# ==============================================================================
# Pinned version rules to ensure immutable execution across remote environments
terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the core AWS infrastructure provider boundaries
provider "aws" {
  region = "us-east-1" # Standard high-availability baseline region
}

# ==============================================================================
# 2. VIRTUAL PRIVATE CLOUD (VPC) CORE NETWORKING LAYERS
# ==============================================================================
# Provision isolated production network boundaries
resource "aws_vpc" "production_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "production-vpc-network"
    Environment = "production-sandbox"
    Orchestration = "Terraform GitOps"
  }
}

# Ingress Route Layer: Public facing edge subnet for external traffic
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.production_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true # Automatically yields interface ingress points

  tags = {
    Name        = "production-public-subnet-1a"
    Tier        = "Public Ingress"
  }
}

# Data Layer: Isolated private subnet with no direct routing from the open internet
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.production_vpc.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name        = "production-private-data-1a"
    Tier        = "Isolated Private"
  }
}

# ==============================================================================
# 3. INTERNET GATEWAY & EDGE SECURITY MANAGEMENT
# ==============================================================================
# Edge hardware mapping to permit routed traffic out to the public internet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.production_vpc.id

  tags = {
    Name = "production-internet-gateway"
  }
}

# Routing Matrix: Map edge ingress rules to point public traffic through the gateway
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.production_vpc.id

  route {
    cidr_block = "0.0.0.0/0" # Catch-all rule mapping to the IGW point
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "production-public-route-table"
  }
}

# Explicitly link the public routing matrix rules to the ingress subnet
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

# ==============================================================================
# 4. NETWORK SECURITY PROFILE CONFIGURATIONS (FIREWALL RULES)
# ==============================================================================
# Security Group architecture to strictly manage network boundary access
resource "aws_security_group" "ssh_ingress_profile" {
  name        = "production-ssh-ingress-profile"
  description = "Enforce secure cryptographic shell verification parameters"
  vpc_id      = aws_vpc.production_vpc.id

  # Ingress Inbound Rule: Allow secure cryptographic connectivity over SSH
  ingress {
    description = "Permit SSH traffic over Transport Layer Layer 4"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # In production, restrict this to a specific home lab IP address
  }

  # Egress Outbound Rule: Permit traffic to securely download container packages
  egress {
    description = "Allow all outbound response streams"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "production-ssh-firewall-profile"
  }
}
