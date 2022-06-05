output "id" {
  description = "The policy ID"
  value       = module.iam_policy.id
}

output "arn" {
  description = "The ARN assigned by AWS to this policy"
  value       = module.iam_policy.arn
}

output "description" {
  description = "The description of the policy"
  value       = module.iam_policy.description
}

output "name" {
  description = "The name of the policy"
  value       = module.iam_policy.name
}

output "path" {
  description = "The path of the policy in IAM"
  value       = module.iam_policy.path
}

output "policy" {
  description = "The policy document"
  value       = module.iam_policy.policy
}

output "iam_role_arn" {
  description = "ARN of IAM role"
  value       = module.iam_assumable_role_ec2.iam_role_arn
}

output "iam_role_name" {
  description = "Name of IAM role"
  value       = module.iam_assumable_role_ec2.iam_role_name
}

output "iam_role_path" {
  description = "Path of IAM role"
  value       = module.iam_assumable_role_ec2.iam_role_path
}

output "iam_role_unique_id" {
  description = "Unique ID of IAM role"
  value       = module.iam_assumable_role_ec2.iam_role_unique_id
}

output "iam_instance_profile_id" {
  description = "IAM Instance profile's ID."
  value       = module.iam_assumable_role_ec2.iam_instance_profile_id
}
