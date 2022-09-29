resource "aws_iam_role" "app_infra_manager_role" {
  name = "app-infra-manager"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

data "aws_iam_policy_document" "app_infra_manager_policy" {
  statement {
    sid    = "CreateAppRunnerServiceLinkeRole"
    effect = "Allow"

    resources = [
      "arn:aws:iam::*:role/aws-service-role/apprunner.amazonaws.com/AWSServiceRoleForAppRunner",
      "arn:aws:iam::*:role/aws-service-role/networking.apprunner.amazonaws.com/AWSServiceRoleForAppRunnerNetworking",
    ]

    actions = ["iam:CreateServiceLinkedRole"]

    condition {
      test     = "StringLike"
      variable = "iam:AWSServiceName"

      values = [
        "apprunner.amazonaws.com",
        "networking.apprunner.amazonaws.com",
      ]
    }
  }

  statement {
    sid       = "PassAnyRoleToAppRunner"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["iam:PassRole"]

    condition {
      test     = "StringLike"
      variable = "iam:PassedToService"
      values   = ["apprunner.amazonaws.com"]
    }
  }

  statement {
    sid       = "AppRunnerAdmin"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["apprunner:*"]
  }

  statement {
    sid    = "CloudformationAdmin"
    effect = "Allow"

    resources = [
      "arn:aws:cloudformation:*:*:*/*",
    ]

    actions = ["cloudformation:*"]
  }
}

resource "aws_iam_policy" "app_infra_manager_policy" {
  name = "app_infra_manager_policy"

  policy = data.aws_iam_policy_document.app_infra_manager_policy.json
}

resource "aws_iam_role_policy_attachment" "app_infra_manager" {
  role       = aws_iam_role.app_infra_manager_role.name
  policy_arn = aws_iam_policy.app_infra_manager_policy.arn
}

resource "aws_iam_user" "app_infra_manager" {
  name = "app_infra_manager"
}

resource "aws_iam_access_key" "app_infra_manager" {
  user = aws_iam_user.app_infra_manager.name
}
