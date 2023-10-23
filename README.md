<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_grafana_license_association.grafana_license_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/grafana_license_association) | resource |
| [aws_grafana_workspace.grafana_workspace](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/grafana_workspace) | resource |
| [aws_grafana_workspace_saml_configuration.grafana_saml](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/grafana_workspace_saml_configuration) | resource |
| [aws_iam_policy.grafana_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.grafana_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.grafana_policy_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.grafana_policy_attach_managed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.grafana_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.grafana_security_group_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.grafana_iam_policy_doc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_subnet.grafana_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_access_type"></a> [account\_access\_type](#input\_account\_access\_type) | The type of account access for the workspace. Valid values are `CURRENT_ACCOUNT` and `ORGANIZATION` | `string` | `"CURRENT_ACCOUNT"` | no |
| <a name="input_authentication_providers"></a> [authentication\_providers](#input\_authentication\_providers) | Authentication providers for the workspace (valid values: `AWS_SSO`, `SAML`, or both) | `list(string)` | <pre>[<br>  "SAML"<br>]</pre> | no |
| <a name="input_configuration"></a> [configuration](#input\_configuration) | The configuration string for the workspace | `string` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment the Grafana Workspace is for i.e. dev, prod etc | `string` | n/a | yes |
| <a name="input_iam_role_force_detach_policies"></a> [iam\_role\_force\_detach\_policies](#input\_iam\_role\_force\_detach\_policies) | Determines whether the workspace IAM role policies will be forced to detach | `bool` | `true` | no |
| <a name="input_iam_role_max_session_duration"></a> [iam\_role\_max\_session\_duration](#input\_iam\_role\_max\_session\_duration) | Maximum session duration (in seconds) that you want to set for the IAM role | `number` | `null` | no |
| <a name="input_iam_role_permissions_boundary"></a> [iam\_role\_permissions\_boundary](#input\_iam\_role\_permissions\_boundary) | ARN of the policy that is used to set the permissions boundary for the IAM role | `string` | `null` | no |
| <a name="input_license_type"></a> [license\_type](#input\_license\_type) | The type of license for the workspace license association. Valid values are `ENTERPRISE` and `ENTERPRISE_FREE_TRIAL` | `string` | `"ENTERPRISE"` | no |
| <a name="input_name"></a> [name](#input\_name) | The Grafana workspace name | `string` | n/a | yes |
| <a name="input_network_access_control"></a> [network\_access\_control](#input\_network\_access\_control) | Configuration for network access to your workspace | `any` | `{}` | no |
| <a name="input_notification_destinations"></a> [notification\_destinations](#input\_notification\_destinations) | The notification destinations. If a data source is specified here, Amazon Managed Grafana will create IAM roles and permissions needed to use these destinations. Must be set to `SNS` | `list(string)` | `[]` | no |
| <a name="input_saml_admin_role_values"></a> [saml\_admin\_role\_values](#input\_saml\_admin\_role\_values) | SAML authentication admin role values | `list(string)` | `[]` | no |
| <a name="input_saml_allowed_organizations"></a> [saml\_allowed\_organizations](#input\_saml\_allowed\_organizations) | SAML authentication allowed organizations | `list(string)` | `[]` | no |
| <a name="input_saml_editor_role_values"></a> [saml\_editor\_role\_values](#input\_saml\_editor\_role\_values) | SAML authentication editor role values | `list(string)` | `[]` | no |
| <a name="input_saml_email_assertion"></a> [saml\_email\_assertion](#input\_saml\_email\_assertion) | SAML authentication email assertion | `string` | `null` | no |
| <a name="input_saml_groups_assertion"></a> [saml\_groups\_assertion](#input\_saml\_groups\_assertion) | SAML authentication groups assertion | `string` | `null` | no |
| <a name="input_saml_idp_metadata_url"></a> [saml\_idp\_metadata\_url](#input\_saml\_idp\_metadata\_url) | SAML authentication IDP Metadata URL. Note that either `saml_idp_metadata_url` or `saml_idp_metadata_xml` must be set | `string` | `null` | no |
| <a name="input_saml_idp_metadata_xml"></a> [saml\_idp\_metadata\_xml](#input\_saml\_idp\_metadata\_xml) | SAML authentication IDP Metadata XML. Note that either `saml_idp_metadata_url` or `saml_idp_metadata_xml` must be set | `string` | `null` | no |
| <a name="input_saml_login_assertion"></a> [saml\_login\_assertion](#input\_saml\_login\_assertion) | SAML authentication email assertion | `string` | `null` | no |
| <a name="input_saml_login_validity_duration"></a> [saml\_login\_validity\_duration](#input\_saml\_login\_validity\_duration) | SAML authentication login validity duration | `number` | `null` | no |
| <a name="input_saml_name_assertion"></a> [saml\_name\_assertion](#input\_saml\_name\_assertion) | SAML authentication name assertion | `string` | `null` | no |
| <a name="input_saml_org_assertion"></a> [saml\_org\_assertion](#input\_saml\_org\_assertion) | SAML authentication org assertion | `string` | `null` | no |
| <a name="input_saml_role_assertion"></a> [saml\_role\_assertion](#input\_saml\_role\_assertion) | SAML authentication role assertion | `string` | `null` | no |
| <a name="input_security_group_rules"></a> [security\_group\_rules](#input\_security\_group\_rules) | Security group rules to add to the security group created | `any` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_vpc_configuration"></a> [vpc\_configuration](#input\_vpc\_configuration) | The configuration settings for an Amazon VPC that contains data sources for your Grafana workspace to connect to | `any` | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
