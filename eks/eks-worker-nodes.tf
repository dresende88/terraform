# EKS Node Group to launch worker nodes

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "node"
  ami_type        = "AL2_x86_64"
  disk_size       = 20
  node_role_arn   = aws_iam_role.eks_node.arn
  subnet_ids      = aws_subnet.subnet[*].id
  remote_access {
    ec2_ssh_key               = "key"
    source_security_group_ids = [aws_security_group.eks_node_remoteAccess.id]
  }
  tags = {
    "kubernetes.io/cluster/${var.cluster-name}"     = "owned"
    "k8s.io/cluster-autoscaler/enabled"             = "true"
    "k8s.io/cluster-autoscaler/${var.cluster-name}" = "owned"
  }
  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node-AmazonEC2ContainerRegistryReadOnly,
  ]
}