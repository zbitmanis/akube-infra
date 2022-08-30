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
  },{ "sid" = "vpcCNIeni",
    "resources" = ["*"]
    "actions" = [
                "ec2:AttachNetworkInterface",
                "ec2:AssignIpv6Addresses",
                "ec2:CreateNetworkInterface",
                "ec2:DeleteNetworkInterface",
                "ec2:DescribeInstances",
                "ec2:DescribeTags",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DescribeInstanceTypes",
                "ec2:DetachNetworkInterface",
                "ec2:ModifyNetworkInterfaceAttribute",
                "ec2:UnassignPrivateIpAddresses",
                "ec2:AssignPrivateIpAddresses"
    ]
  },{ "sid" = "vpcCNItags",
        "effect": "Allow",
        "actions": [
            "ec2:CreateTags"
        ],
        "resources": [
            "arn:aws:ec2:*:*:network-interface/*"
        ]
  },{
            "sid": "ECRallow"
            "effect": "Allow",
            "actions": [
                "ecr:BatchCheckLayerAvailability",
                "ecr:BatchGetImage",
                "ecr:GetDownloadUrlForLayer",
                "ecr:GetAuthorizationToken"
            ],
            "resources": ["*"]
    }

]
