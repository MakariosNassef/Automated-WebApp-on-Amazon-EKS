output "OIDC_OUT" {
  description = "The OIDC provider URL for your Amazon EKS cluster"
  value = flatten(aws_eks_cluster.eks.identity[*].oidc[*].issuer)[0]
}

