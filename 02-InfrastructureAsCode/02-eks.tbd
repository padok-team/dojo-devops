###################
### EKS cluster ###
###################

resource "aws_eks_cluster" "this" {
  name     = local.eks.cluster.name
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    endpoint_public_access = true
    public_access_cidrs    = concat([local.my_ip], formatlist("%s/32", module.vpc.nat_public_ips)) # restrict to your public IP
    subnet_ids             = module.vpc.private_subnets
  }

  tags = {
    Name = local.eks.cluster.name
  }

  version = local.eks.cluster.version
}

data "tls_certificate" "eks" {
  url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "this" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_role_arn   = aws_iam_role.eks_node.arn
  node_group_name = "eks_nodes_${local.owner}"
  capacity_type   = local.eks.node.capacity_type
  instance_types  = local.eks.node.instance_types


  scaling_config {
    min_size     = local.eks.node.scaling_config.min_size
    max_size     = local.eks.node.scaling_config.max_size
    desired_size = local.eks.node.scaling_config.desired_size
  }

  subnet_ids = module.vpc.private_subnets

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}

################
### Policies ###
################

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "eks_cluster" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "cluster_autoscaler_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.this.arn]
    }
  }
}

data "aws_iam_policy_document" "cluster_autoscaler" {
  statement {
    actions = [
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup"
    ]

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/k8s.io/cluster-autoscaler/${aws_eks_cluster.this.name}"
      values   = ["owned"]
    }
  }

  statement {
    actions = [
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeAutoScalingGroups",
      "ec2:DescribeLaunchTemplateVersions",
      "autoscaling:DescribeTags",
      "autoscaling:DescribeLaunchConfigurations"
    ]

    resources = ["*"]
  }
}

#################
### IAM roles ###
#################

resource "aws_iam_role" "eks_cluster" {
  name               = local.eks.cluster.name
  assume_role_policy = data.aws_iam_policy_document.eks_cluster.json
}

resource "aws_iam_role" "eks_node" {
  name               = "eks_node_${local.owner}"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

resource "aws_iam_role" "cluster_autoscaler" {
  name               = "cluster_autoscaler_${local.owner}"
  assume_role_policy = data.aws_iam_policy_document.cluster_autoscaler_role.json
}

resource "aws_iam_policy" "cluster_autoscaler" {
  name   = "cluster_autoscaler_${local.owner}"
  policy = data.aws_iam_policy_document.cluster_autoscaler.json
}

###################################
### IAM Role policy attachments ###
###################################

# EKS
resource "aws_iam_role_policy_attachment" "eks_cluster" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "eks_node_worker" {
  role       = aws_iam_role.eks_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_node_ecr_ro" {
  role       = aws_iam_role.eks_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "eks_node_cni" {
  role       = aws_iam_role.eks_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks_node_ssm" {
  role       = aws_iam_role.eks_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {
  role       = aws_iam_role.cluster_autoscaler.name
  policy_arn = aws_iam_policy.cluster_autoscaler.arn
}
