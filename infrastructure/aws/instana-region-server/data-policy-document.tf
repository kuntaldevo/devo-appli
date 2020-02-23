data "aws_iam_policy_document" "policy"
{
  statement
  {
    actions = [
      "dynamodb:ListTables",
      "dynamodb:DescribeTable",
      "dynamodb:ListTagsOfResource",
      "ec2:DescribeInstances",
      "ec2:DescribeTags",
      "elasticache:ListTagsForResource",
      "elasticache:DescribeCacheClusters",
      "elasticache:DescribeEvents",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeTags",
      "kinesis:ListStreams",
      "kinesis:DescribeStream",
      "kinesis:ListTagsForStream",
      "lambda:ListTags",
      "lambda:ListFunctions",
      "lambda:GetFunctionConfiguration",
      "rds:Describe*",
      "rds:ListTagsForResource",
      "s3:GetBucketTagging",
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation",
      "sqs:ListQueues",
      "sqs:GetQueueAttributes",
      "sqs:ListQueueTags",
      "xray:BatchGetTraces",
      "xray:GetTraceSummaries"
    ],
    effect = "Allow"
    resources = ["*"]
  },
  statement {
    actions = [
        "cloudwatch:GetMetricStatistics",
        "cloudwatch:ListMetrics"
    ],
    effect = "Allow"
    resources = ["*"]
  }
}


data "aws_iam_policy_document" "assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
