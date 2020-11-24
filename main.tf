terraform {
  required_providers {
    signalfx = {
      source  = "splunk-terraform/signalfx"
      version = "6.1.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "null" {
  version = "3.0.0"
}

provider "aws" {
  profile = var.profile
  region  = var.region
}

// Create the AWS policy first, so we can get the AWS account ID before 
// creating the Splunk IMT integration.
resource "aws_iam_policy" "splunk_imt_policy" {
  name   = "SplunkIMTPolicy"
  policy = data.aws_iam_policy_document.splunk_imt_policy_doc.json
}

// Extract the AWS account ID from the policy ARN.
data "aws_arn" "arn_fields" {
  arn = aws_iam_policy.splunk_imt_policy.arn
}

// Use the AWS account ID as the integration name.
resource "signalfx_aws_external_integration" "new" {
  name = data.aws_arn.arn_fields.account
}

data "aws_iam_policy_document" "splunk_imt_role_doc" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type  = "AWS"
      identifiers = [signalfx_aws_external_integration.new.signalfx_aws_account]
    }

    condition {
      test   = "StringEquals"
      variable = "sts:ExternalId"
      values   = [signalfx_aws_external_integration.new.external_id]
    }
  }
}

resource "aws_iam_role" "splunk_imt_role" {
  name     = "SplunkIMTRole"
  assume_role_policy = data.aws_iam_policy_document.splunk_imt_role_doc.json
}

resource "aws_iam_role_policy_attachment" "splunk_imt" {
  role       = aws_iam_role.splunk_imt_role.name
  policy_arn = aws_iam_policy.splunk_imt_policy.arn
}

// This is a hack to deal with Splunk IMT validating the AWS integration too 
// quickly and failing.  It waits 10 seconds before the final step.
resource "null_resource" "delay" {
  provisioner "local-exec" {
    command = "sleep 10"
  }
  triggers = {
    "splunk_imt" = aws_iam_role_policy_attachment.splunk_imt.id
  }
}

resource "signalfx_aws_integration" "last_step" {
  enabled            = true
  integration_id     = signalfx_aws_external_integration.new.id
  external_id        = signalfx_aws_external_integration.new.external_id
  role_arn           = aws_iam_role.splunk_imt_role.arn
  poll_rate          = 300
  import_cloud_watch = true
  enable_aws_usage   = false

  depends_on = [null_resource.delay]
}
