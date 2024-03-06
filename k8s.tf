
# WORK IN PROGRESS
resource "aws_eks_cluster" "my_cluster" {
  name     = "my-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = aws_subnet.public.*.id
  }
}

# IAM role for EKS cluster
resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "eks.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

# Attach policies to EKS cluster role
resource "aws_iam_role_policy_attachment" "eks_cluster_role_attachment" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_service_role_attachment" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

# Create public subnets
resource "aws_subnet" "public" {

  count             = 2  # Update with the desired number of public subnets
  vpc_id            = data.aws_vpc.main.id
  cidr_block        = cidrsubnet(data.aws_vpc.main.cidr_block, 8, count.index)
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"  # Update with desired AZs
}

# Node group security group
resource "aws_security_group" "node_group_sg" {
  name        = "node-group-sg"
  description = "Security group for EKS node group"
  vpc_id      = data.aws_vpc.main.id
  
  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 30007
    to_port     = 30007
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create EKS node group
resource "aws_eks_node_group" "my_node_group" {
  cluster_name    = aws_eks_cluster.my_cluster.name
  node_group_name = "my-node-group"
  node_role_arn   = aws_iam_role.eks_cluster_role.arn
  subnet_ids      = aws_subnet.public[*].id
  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }
  instance_types = ["t3.medium"]
  remote_access {
    ec2_ssh_key = "my-ssh-key"  # Update with your SSH key name
  }
  launch_template {
    name = "my-launch-template"
    version = "$Latest"  # Use latest version of launch template
  }
  depends_on = [aws_security_group.node_group_sg]
}

# Data source to get default VPC
data "aws_vpc" "main" {
  default = true
  id = "vpc-0fc26fe53d6c17730"
}

# Data source to get default security group
data "aws_security_group" "default" {
  name   = "default"
  vpc_id = data.aws_vpc.main.id
}
