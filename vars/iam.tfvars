iam_ec2_policy_statemnts = [
  { "sid" = "DynamoDBAccessForClusterJoin",
    "actions" = ["dynamodb:*"],
    "resources" = ["*"]
  },
  { "sid" = "ECRReadOnly",
    "actions" = [
    "ecr:BatchCheckLayerAvailability",
    "ecr:BatchGetImage",
    "ecr:GetDownloadUrlForLayer",
    "ecr:GetAuthorizationToken"
    ],
    "resources" = ["*"]
  }
]
