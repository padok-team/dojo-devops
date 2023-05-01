output cluster_name {
  value       = aws_eks_cluster.this.name
  description = "EKS Cluster name"
}

output cluster_autoscaler_role_arn {
    value       = aws_iam_role.cluster_autoscaler.arn
    description = "EKS Cluster Autoscaler IAM Role ARN"
}

output gitlab_runner_role_arn {
    value       = aws_iam_role.gitlab_runner.arn
    description = "Gitlab Runner IAM Role ARN"
}

output ecr_repository {
    value       = aws_ecr_repository.this.name
    description = "ECR Repository for docker images"
}
