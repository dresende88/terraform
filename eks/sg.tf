# EC2 Security Group to allow networking traffic with EKS cluster

resource "aws_security_group" "eks_cluster" {
  name        = "eks-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-cluster"
  }
}

resource "aws_security_group_rule" "cluster_ingress_workstation_https" {
  cidr_blocks       = [local.workstation-external-cidr]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.eks_cluster.id
  to_port           = 443
  type              = "ingress"
}

# EC2 Security Group for all nodes in the nodeGroup to allow SSH access

resource "aws_security_group" "eks_node_remoteAccess" {
  name        = "eks-node-remoteAccess"
  description = "Security group for all nodes in the nodeGroup to allow SSH access"
  vpc_id      = aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-node-remote-access"
  }
}

resource "aws_security_group_rule" "node_ingress_workstation_ssh" {
  cidr_blocks       = [local.workstation-external-cidr]
  description       = "Allow workstation to access nodes via SSH"
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.eks_cluster.id
  to_port           = 22
  type              = "ingress"
}