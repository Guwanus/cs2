# ECS task execution role (pull from ECR, send logs)
resource "aws_iam_role" "ecs_task_execution" {
  name               = "${var.project}-ecsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_assume.json
}

data "aws_iam_policy_document" "ecs_tasks_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs_exec_policy" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS task role (app permissions → DynamoDB)
resource "aws_iam_role" "ecs_task_role" {
  name               = "${var.project}-ecsTaskRole"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_assume.json
}

data "aws_iam_policy_document" "ddb_access" {
  statement {
    effect    = "Allow"
    actions   = ["dynamodb:PutItem", "dynamodb:UpdateItem", "dynamodb:DescribeTable"]
    resources = [aws_dynamodb_table.events.arn]
  }
}

resource "aws_iam_role_policy" "ecs_task_ddb" {
  name   = "${var.project}-ecsTaskDdbPolicy"
  role   = aws_iam_role.ecs_task_role.id
  policy = data.aws_iam_policy_document.ddb_access.json
}

# Lambda role
resource "aws_iam_role" "lambda_role" {
  name               = "${var.project}-lambdaRole"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
}

# Lambda assume-role policy
data "aws_iam_policy_document" "lambda_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda_policy" {
  statement {
    effect    = "Allow"
    actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["arn:aws:logs:${var.region}:*:log-group:/aws/lambda/*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["dynamodb:PutItem", "dynamodb:DescribeTable"]
    resources = [aws_dynamodb_table.events.arn]
  }
}

resource "aws_iam_policy" "lambda_inline" {
  name   = "${var.project}-lambdaPolicy"
  policy = data.aws_iam_policy_document.lambda_policy.json
}

resource "aws_iam_role_policy_attachment" "lambda_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_inline.arn
}