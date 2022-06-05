variable "iam_ec2_policy_statemnts" {
  description = "Configuration block for the ec2 policy statement"
  type = list(object({
    sid       = string
    actions   = list(string)
    resources = list(string)
  }))
  default = []
}
