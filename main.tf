resource "aws_grafana_workspace" "grafana_workspace" {

  name                      = var.name
  account_access_type       = var.account_access_type
  authentication_providers  = var.authentication_providers
  permission_type           = 'SERVICE_MANAGED'

  configuration             = var.configuration
  data_sources              = ['AMAZON_OPENSEARCH_SERVICE','CLOUDWATCH','PROMETHEUS']
  description               = "Managed by Terraform"
  grafana_version           = "9.4"
  notification_destinations = var.notification_destinations
  role_arn                  = aws_iam_role.grafana_iam_role.arn

  dynamic "network_access_control" {
    for_each = length(var.network_access_control) > 0 ? [var.network_access_control] : []

    content {
      prefix_list_ids = network_access_control.value.prefix_list_ids
      vpce_ids        = network_access_control.value.vpce_ids
    }
  }

  dynamic "vpc_configuration" {
    for_each = length(var.vpc_configuration) > 0 ? [var.vpc_configuration] : []

    content {
      security_group_ids = flatten(concat([aws_security_group.grafana_security_group.id], try(vpc_configuration.value.security_group_ids, []))) : vpc_configuration.value.security_group_ids
      subnet_ids         = vpc_configuration.value.subnet_ids
    }
  }

  tags = merge(
    var.tags,
    {
      "Name" = format("%s-%s", var.environment, var.name)
    },
    {
      "Env" = var.environment
    },
  )
}

data "aws_subnet" "grafana_subnet" {

  id = element(var.vpc_configuration.subnet_ids, 0)
}

resource "aws_security_group" "grafana_security_group" {

  name        = "aws-grafana-${var.name}"
  description = "Managed by Terraform"
  vpc_id      = data.aws_subnet.grafana_subnet[0].vpc_id

  tags = merge(
    var.tags,
    {
      "Name" = format("%s-%s", var.environment, var.name)
    },
    {
      "Env" = var.environment
    },
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "grafana_security_group_rule" {
  for_each = { for k, v in var.security_group_rules : k => v }

  # Required
  security_group_id = aws_security_group.grafana_security_group.id
  protocol          = each.value.protocol
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  type              = try(each.value.type, "egress")

  # Optional
  description              = "Managed by Terraform"
  cidr_blocks              = lookup(each.value, "cidr_blocks", null)
  ipv6_cidr_blocks         = lookup(each.value, "ipv6_cidr_blocks", null)
  prefix_list_ids          = lookup(each.value, "prefix_list_ids", null)
  self                     = lookup(each.value, "self", null)
  source_security_group_id = lookup(each.value, "source_security_group_id", null)
}

data "aws_iam_policy_document" "assume" {

  statement {
    sid     = "GrafanaAssume"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["grafana.${data.aws_partition.current.dns_suffix}"]
    }
  }
}

resource "aws_iam_role" "grafana_iam_role" {

  name        = "AWSGrafanaServiceRole-${var.name}"
  description = "Managed by Terraform"

  assume_role_policy    = data.aws_iam_policy_document.assume.json
  force_detach_policies = var.iam_role_force_detach_policies
  max_session_duration  = var.iam_role_max_session_duration
  permissions_boundary  = var.iam_role_permissions_boundary

  tags = merge(
    var.tags,
    {
      "Name" = format("%s-%s", var.environment, var.name)
    },
    {
      "Env" = var.environment
    },
  )
}

resource "aws_iam_role_policy_attachment" "additional" {
  for_each = { for k, v in var.iam_role_policy_arns : k => v }

  role       = aws_iam_role.grafana_iam_role.name
  policy_arn = each.value
}

data "aws_iam_policy_document" "grafana_iam_policy_doc" {

  dynamic "statement" {
    for_each = contains(var.data_sources, "AMAZON_OPENSEARCH_SERVICE") ? [1] : []

    content {
      actions = [
        "es:ESHttpGet",
        "es:DescribeElasticsearchDomains",
        "es:ListDomainNames",
      ]
      resources = ["*"]
    }
  }

  dynamic "statement" {
    for_each = contains(var.data_sources, "AMAZON_OPENSEARCH_SERVICE") ? [1] : []

    content {
      actions = [
        "es:ESHttpPost",
      ]
      resources = [
        "arn:${data.aws_partition.current.partition}:es:*:*:domain/*/_msearch*",
        "arn:${data.aws_partition.current.partition}:es:*:*:domain/*/_opendistro/_ppl",
      ]
    }
  }

  dynamic "statement" {
    for_each = contains(var.data_sources, "PROMETHEUS") ? [1] : []

    content {
      actions = [
        "aps:ListWorkspaces",
        "aps:DescribeWorkspace",
        "aps:QueryMetrics",
        "aps:GetLabels",
        "aps:GetSeries",
        "aps:GetMetricMetadata",
      ]
      resources = ["*"]
    }
  }

  dynamic "statement" {
    for_each = contains(var.notification_destinations, "SNS") ? [1] : []

    content {
      actions = [
        "sns:Publish",
      ]
      resources = ["arn:${data.aws_partition.current.partition}:sns:*:${data.aws_caller_identity.current.account_id}:grafana*"]
    }
  }
}

resource "aws_iam_policy" "grafana_iam_policy" {

  name        = "aws-grafana-${var.name}-policy-"
  description = "Managed by Terraform"
  policy      = data.aws_iam_policy_document.grafana_iam_policy_doc.json

  tags = merge(
    var.tags,
    {
      "Name" = format("%s-%s", var.environment, var.name)
    },
    {
      "Env" = var.environment
    },
  )
}

resource "aws_iam_role_policy_attachment" "grafana_policy_attach" {
  for_each = { for k, v in local.policies_to_attach : k => v && v.attach }

  role       = aws_iam_role.grafana_iam_role.name
  policy_arn = each.value.arn
}

resource "aws_iam_role_policy_attachment" "grafana_policy_attach_managed" {

  role       = aws_iam_role.grafana_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonGrafanaCloudWatchAccess"
}

resource "aws_grafana_workspace_saml_configuration" "grafana_saml" {

  admin_role_values       = var.saml_admin_role_values
  allowed_organizations   = var.saml_allowed_organizations
  editor_role_values      = var.saml_editor_role_values
  email_assertion         = var.saml_email_assertion
  groups_assertion        = var.saml_groups_assertion
  idp_metadata_url        = var.saml_idp_metadata_url
  idp_metadata_xml        = var.saml_idp_metadata_xml
  login_assertion         = var.saml_login_assertion
  login_validity_duration = var.saml_login_validity_duration
  name_assertion          = var.saml_name_assertion
  org_assertion           = var.saml_org_assertion
  role_assertion          = var.saml_role_assertion
  workspace_id            = aws_grafana_workspace.grafana_workspace.id
}

resource "aws_grafana_license_association" "grafana_license_association" {

  license_type = var.license_type
  workspace_id = aws_grafana_workspace.grafana_workspace.id
}
