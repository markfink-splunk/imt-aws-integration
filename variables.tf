variable "profile" {
    description = "AWS configuration profile"
}

variable "region" {
    description = "AWS region to use"
}

data "aws_iam_policy_document" "splunk_imt_policy_doc" {
  statement {
    actions = [
      "dynamodb:ListTables",
      "dynamodb:DescribeTable",
      "dynamodb:ListTagsOfResource",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeVolumes",
      "ec2:DescribeReservedInstances",
      "ec2:DescribeReservedInstancesModifications",
      "ec2:DescribeTags",
      "ec2:DescribeRegions",
      "organizations:DescribeOrganization",
      "cloudwatch:ListMetrics",
      "cloudwatch:GetMetricData",
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:DescribeAlarms",
      "sqs:ListQueues",
      "sqs:GetQueueAttributes",
      "sqs:ListQueueTags",
      "elasticmapreduce:ListClusters",
      "elasticmapreduce:DescribeCluster",
      "kinesis:ListShards",
      "kinesis:ListStreams",
      "kinesis:DescribeStream",
      "kinesis:ListTagsForStream",
      "rds:DescribeDBInstances",
      "rds:ListTagsForResource",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeTags",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticache:DescribeCacheClusters",
      "redshift:DescribeClusters",
      "lambda:GetAlias",
      "lambda:ListFunctions",
      "lambda:ListTags",
      "autoscaling:DescribeAutoScalingGroups",
      "s3:ListAllMyBuckets",
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:GetBucketTagging",
      "ecs:ListServices",
      "ecs:ListTasks",
      "ecs:DescribeTasks",
      "ecs:DescribeServices",
      "ecs:ListClusters",
      "ecs:DescribeClusters",
      "ecs:ListTaskDefinitions",
      "ecs:ListTagsForResource",
      "apigateway:GET",
      "cloudfront:ListDistributions",
      "cloudfront:ListTagsForResource",
      "tag:GetResources",
      "es:ListDomainNames",
      "es:DescribeElasticsearchDomain"
    ]
    resources = ["*"]
  }
}
