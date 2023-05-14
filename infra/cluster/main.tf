# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster
resource "aws_eks_cluster" "eks" {
  name = var.CLUSTER_NAME 
  # The Amazon Resource Name (ARN) of the IAM role that provides permissions for 
  # the Kubernetes control plane to make calls to AWS API operations on your behalf
  role_arn = aws_iam_role.eks_cluster.arn
  version  = "1.24" 
  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true

    subnet_ids = [
      var.PUBLIC_SUBNET_ID,
      var.PRIVATE_SUBNET_ID,
      var.PUBLIC_SUBNET_ID_2,
    ]
  }
  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks-cluster-AmazonEKSClusterPolicy,
    # aws_iam_role_policy_attachment.eks-cluster-AmazonEKSVPCResourceController,
  ]
}

# Resource: aws_iam_role
resource "aws_iam_role" "eks_cluster" {
  name = "eks-cluster"

  # The policy that grants an entity permission to assume the role.
  # The role that Amazon EKS will use to create AWS resources for Kubernetes clusters
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# Resource: aws_iam_role_policy_attachment
resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}



