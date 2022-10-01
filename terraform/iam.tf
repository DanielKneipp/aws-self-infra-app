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
    sid       = "CloudformationAdmin"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["cloudformation:*"]
  }
}

resource "aws_iam_policy" "app_infra_manager_policy" {
  name   = "app_infra_manager_policy"
  policy = data.aws_iam_policy_document.app_infra_manager_policy.json
}
