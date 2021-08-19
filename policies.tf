data "aws_iam_policy_document" "docker-ecr-ro" {
    statement {
        actions = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
        ]

        resources = [
            "*",
        ]
        
        condition {
          test     = "ForAllValues:StringEquals"
          variable = "ecr:ResourceTag/BaseImage"
          values = [
            "true"
          ]
        }
    }
}

data "aws_iam_policy_document" "docker-ecr-full" {
    statement {
        actions = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]

        resources = [
            "*",
        ]

        condition {
          test     = "ForAllValues:StringEquals"
          variable = "ecr:ResourceTag/BaseImage"
          values = [
            "true"
          ]
        }
    }
}

resource "aws_iam_policy" "docker-ecr-ro" {
    name   = "sd-staging-docker-ecr-ro-permissons"
    path   = "/services/"
    policy = data.aws_iam_policy_document.docker-ecr-ro.json
}

resource "aws_iam_policy" "docker-ecr-full" {
    name   = "sd-staging-docker-ecr-full-permissons"
    path   = "/services/"
    policy = data.aws_iam_policy_document.docker-ecr-full.json
}