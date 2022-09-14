resource "aws_iam_policy" "gitlab_runner" {
  name   = "gitlab_runner_${local.owner}"
  policy = data.aws_iam_policy_document.gitlab_runner.json
}

resource "aws_iam_role" "gitlab_runner" {
  name               = "gitlab_runner_${local.owner}"
  assume_role_policy = data.aws_iam_policy_document.cluster_autoscaler_role.json
}

resource "aws_iam_role_policy_attachment" "gitlab_runner" {
  role       = aws_iam_role.gitlab_runner.name
  policy_arn = aws_iam_policy.gitlab_runner.arn
}

data "aws_iam_policy_document" "gitlab_runner_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.this.arn]
    }
  }
}

data "aws_iam_policy_document" "gitlab_runner" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "ecr:*"
    ]

    resources = [
      "*"
    ]
  }
}
