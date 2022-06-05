iam_ec2_policy_statemnts = [
  { "sid" = "DynamoDBAccessForClusterJoin",
    "actions" = ["dynamodb:*"],
    "resources" = ["*"]
  }
]
