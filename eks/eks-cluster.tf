# EKS Cluster

resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster-name
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    cluster_security_group_id = aws_security_group.eks_cluster.id
    endpoint_private_access = false
    endpoint_public_access = true
    public_access_cidrs = 
    security_group_ids = [aws_security_group.eks_cluster.id]
    subnet_ids         = aws_subnet.subnet[*].id
    vpc_id = aws_vpc.vpc.id
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster-AmazonEKSServicePolicy,
  ]
}