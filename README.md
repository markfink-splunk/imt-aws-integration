# imt-aws-integration

This Terraform script automates the configuration of the AWS integration for Splunk IMT.  It can be run for one or many AWS accounts, dramatically speeding up the time to configure the integration.

You can use it like any Terraform script by downloading the files into a directory and running "terraform init", "terraform plan", and "terraform apply".  

# Requirements

1. You must have the AWS CLI installed and configured with profiles for your AWS account(s).  This includes access and secret keys for a user with sufficient rights (see below) to configure the integration.  It will also help if you configure a default region for each profile.

2. The Splunk IMT access token and API URL are expected to be configured via environment variables:  SFX_AUTH_TOKEN and SFX_API_URL.  See this link for more details:  https://registry.terraform.io/providers/splunk-terraform/signalfx/latest/docs

3. The access token must be a session token configured for an admin user in Splunk IMT.  This is different from an org token.  See this link for more details:  https://dev.splunk.com/observability/docs/administration/authtokens.  To configure a session token in Splunk IMT, click on your profile (upper right), Organization Settings, Members. Select an admin user.  Look for a link for "Generate User API Access Token".  That's what you need for this.

# AWS Access Rights

The AWS user that Terraform uses must minimally have the following rights.  The script names the integration policy and role as you see below in the Resource section.  This policy allows for both applying and destroying the Terraform plan.  The x's in the arn's below should be the AWS account number.  This policy is as restrictive as it can be.  A more liberal policy is of course ok.
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "iam:GetRole",
                "iam:GetPolicyVersion",
                "iam:GetPolicy",
                "iam:DeletePolicy",
                "iam:CreateRole",
                "iam:DeleteRole",
                "iam:AttachRolePolicy",
                "iam:CreatePolicy",
                "iam:ListInstanceProfilesForRole",
                "iam:DetachRolePolicy",
                "iam:ListPolicyVersions",
                "iam:ListAttachedRolePolicies"
            ],
            "Resource": [
                "arn:aws:iam::xxxxxxxxxxxx:role/SplunkIMTRole",
                "arn:aws:iam::xxxxxxxxxxxx:policy/SplunkIMTPolicy"
            ]
        }
    ]
}
```

# Usage

If you want to run the script for a single AWS account, then simply run "terraform apply".  It will prompt you for the AWS profile and region to use.  The region does not make any difference; it simply needs to be set for the AWS Terraform provider to work.  It will pull the AWS credentials from the AWS profile you have locally configured.

If you want to run the script for all AWS profiles you have configured, then run the all_accounts.sh script.  It reads in the list of profiles and loops over them, running "terraform apply" for each and saving state for each in its own tfstate file.

It names the AWS integration in Splunk IMT using the AWS account ID.

It uses the recommended IAM policy from the Splunk IMT docs per this link:
https://docs.signalfx.com/en/latest/integrations/amazon-web-services.html

You can edit the policy in variables.tf if you like.
