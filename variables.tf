variable "name" {
  description = "The Grafana workspace name"
  type        = string
}

variable "environment" {
  description = "The environment the Grafana Workspace is for i.e. dev, prod etc"
}

variable "tags" {
  type        = map(string)
  default     = {}
}

variable "account_access_type" {
  description = "The type of account access for the workspace. Valid values are `CURRENT_ACCOUNT` and `ORGANIZATION`"
  type        = string
  default     = "CURRENT_ACCOUNT"
}

variable "authentication_providers" {
  description = "Authentication providers for the workspace (valid values: `AWS_SSO`, `SAML`, or both)"
  type        = list(string)
  default     = ["SAML"]
}

variable "configuration" {
  description = "The configuration string for the workspace"
  type        = string
  default     = null
}

variable "network_access_control" {
  description = "Configuration for network access to your workspace"
  type        = any
  default     = {}
}

variable "notification_destinations" {
  description = "The notification destinations. If a data source is specified here, Amazon Managed Grafana will create IAM roles and permissions needed to use these destinations. Must be set to `SNS`"
  type        = list(string)
  default     = []
}

variable "organization_role_name" {
  description = "The role name that the workspace uses to access resources through Amazon Organizations"
  type        = string
  default     = null
}

variable "organizational_units" {
  description = "The Amazon Organizations organizational units that the workspace is authorized to use data sources from"
  type        = list(string)
  default     = []
}

variable "vpc_configuration" {
  description = "The configuration settings for an Amazon VPC that contains data sources for your Grafana workspace to connect to"
  type        = any
  default     = {}
}

variable "iam_role_force_detach_policies" {
  description = "Determines whether the workspace IAM role policies will be forced to detach"
  type        = bool
  default     = true
}

variable "iam_role_max_session_duration" {
  description = "Maximum session duration (in seconds) that you want to set for the IAM role"
  type        = number
  default     = null
}

variable "iam_role_permissions_boundary" {
  description = "ARN of the policy that is used to set the permissions boundary for the IAM role"
  type        = string
  default     = null
}

variable "iam_role_policy_arns" {
  description = "List of ARNs of IAM policies to attach to the workspace IAM role"
  type        = list(string)
  default     = []
}

variable "saml_admin_role_values" {
  description = "SAML authentication admin role values"
  type        = list(string)
  default     = []
}

variable "saml_allowed_organizations" {
  description = "SAML authentication allowed organizations"
  type        = list(string)
  default     = []
}

variable "saml_editor_role_values" {
  description = "SAML authentication editor role values"
  type        = list(string)
  default     = []
}

variable "saml_email_assertion" {
  description = "SAML authentication email assertion"
  type        = string
  default     = null
}

variable "saml_groups_assertion" {
  description = "SAML authentication groups assertion"
  type        = string
  default     = null
}

variable "saml_idp_metadata_url" {
  description = "SAML authentication IDP Metadata URL. Note that either `saml_idp_metadata_url` or `saml_idp_metadata_xml`"
  type        = string
  default     = null
}

variable "saml_idp_metadata_xml" {
  description = "SAML authentication IDP Metadata XML. Note that either `saml_idp_metadata_url` or `saml_idp_metadata_xml`"
  type        = string
  default     = null
}

variable "saml_login_assertion" {
  description = "SAML authentication email assertion"
  type        = string
  default     = null
}

variable "saml_login_validity_duration" {
  description = "SAML authentication login validity duration"
  type        = number
  default     = null
}

variable "saml_name_assertion" {
  description = "SAML authentication name assertion"
  type        = string
  default     = null
}

variable "saml_org_assertion" {
  description = "SAML authentication org assertion"
  type        = string
  default     = null
}

variable "saml_role_assertion" {
  description = "SAML authentication role assertion"
  type        = string
  default     = null
}

variable "license_type" {
  description = "The type of license for the workspace license association. Valid values are `ENTERPRISE` and `ENTERPRISE_FREE_TRIAL`"
  type        = string
  default     = "ENTERPRISE"
}

variable "security_group_rules" {
  description = "Security group rules to add to the security group created"
  type        = any
  default     = {}
}
