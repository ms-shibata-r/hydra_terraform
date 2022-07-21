provider "aws" {
  region  = "ap-northeast-1"
}

# ----------------------------------
# VPC
# ----------------------------------
resource "aws_vpc" "hydra_vpc" {
  cidr_block                       = "10.0.0.0/16"
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name = "hydra-vpc"
  }
}

# ----------------------------------
# Subnet
# ----------------------------------
resource "aws_subnet" "hydra_public_subnet_a" {
  vpc_id                          = aws_vpc.hydra_vpc.id
  cidr_block                      = "10.0.10.0/24"
  assign_ipv6_address_on_creation = "false"
  map_public_ip_on_launch         = "false"
  availability_zone               = "ap-northeast-1a"

  tags = {
    Name = "hydra_public_subnet_a"
  }
}

resource "aws_subnet" "hydra_public_subnet_c" {
  vpc_id                          = aws_vpc.hydra_vpc.id
  cidr_block                      = "10.0.30.0/24"
  assign_ipv6_address_on_creation = "false"
  map_public_ip_on_launch         = "false"
  availability_zone               = "ap-northeast-1c"

  tags = {
    Name = "hydra_public_subnet_c"
  }
}

resource "aws_subnet" "hydra_public_subnet_d" {
  vpc_id                          = aws_vpc.hydra_vpc.id
  cidr_block                      = "10.0.50.0/24"
  assign_ipv6_address_on_creation = "false"
  map_public_ip_on_launch         = "false"
  availability_zone               = "ap-northeast-1d"

  tags = {
    Name = "hydra_public_subnet_d"
  }
}

resource "aws_subnet" "hydra_private_subnet_a" {
  vpc_id                          = aws_vpc.hydra_vpc.id
  cidr_block                      = "10.0.20.0/24"
  assign_ipv6_address_on_creation = "false"
  map_public_ip_on_launch         = "false"
  availability_zone               = "ap-northeast-1a"

  tags = {
    Name = "hydra_private_subnet_a"
  }
}

resource "aws_subnet" "hydra_private_subnet_c" {
  vpc_id                          = aws_vpc.hydra_vpc.id
  cidr_block                      = "10.0.40.0/24"
  assign_ipv6_address_on_creation = "false"
  map_public_ip_on_launch         = "false"
  availability_zone               = "ap-northeast-1c"

  tags = {
    Name = "hydra_private_subnet_c"
  }
}

resource "aws_subnet" "hydra_private_subnet_d" {
  vpc_id                          = aws_vpc.hydra_vpc.id
  cidr_block                      = "10.0.60.0/24"
  assign_ipv6_address_on_creation = "false"
  map_public_ip_on_launch         = "false"
  availability_zone               = "ap-northeast-1d"

  tags = {
    Name = "hydra_private_subnet_d"
  }
}

resource "aws_subnet" "api_facede_subnet_a" {
  vpc_id                          = aws_vpc.hydra_vpc.id
  cidr_block                      = "10.0.80.0/24"
  assign_ipv6_address_on_creation = "false"
  map_public_ip_on_launch         = "false"
  availability_zone               = "ap-northeast-1a"

  tags = {
    Name = "api_facede_subnet_a"
  }
}

resource "aws_subnet" "api_facede_subnet_c" {
  vpc_id                          = aws_vpc.hydra_vpc.id
  cidr_block                      = "10.0.81.0/24"
  assign_ipv6_address_on_creation = "false"
  map_public_ip_on_launch         = "false"
  availability_zone               = "ap-northeast-1c"

  tags = {
    Name = "api_facede_subnet_c"
  }
}

resource "aws_subnet" "api_facede_subnet_d" {
  vpc_id                          = aws_vpc.hydra_vpc.id
  cidr_block                      = "10.0.82.0/24"
  assign_ipv6_address_on_creation = "false"
  map_public_ip_on_launch         = "false"
  availability_zone               = "ap-northeast-1d"

  tags = {
    Name = "api_facede_subnet_d"
  }
}

# ----------------------------------
# InternetGateway
# ----------------------------------
resource "aws_internet_gateway" "hydra_igw" {
  vpc_id = aws_vpc.hydra_vpc.id
  tags = {
    Name = "hydra_igw"
  }
}

# ----------------------------------
# RouteTable
# ----------------------------------
resource "aws_route_table" "hydra_rt" {
  vpc_id = aws_vpc.hydra_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.hydra_igw.id
  }

  tags = {
    Name = "hydra_rt"
  }
}

# ----------------------------------
# RouteTableをVPCとSubnetに紐付け
# ----------------------------------
resource "aws_main_route_table_association" "hydra_rt_vpc" {
  vpc_id         = aws_vpc.hydra_vpc.id
  route_table_id = aws_route_table.hydra_rt.id
}

resource "aws_route_table_association" "hydra_rt_public_subnet_a" {
  subnet_id      = aws_subnet.hydra_public_subnet_a.id
  route_table_id = aws_route_table.hydra_rt.id
}

resource "aws_route_table_association" "hydra_rt_public_subnet_c" {
  subnet_id      = aws_subnet.hydra_public_subnet_c.id
  route_table_id = aws_route_table.hydra_rt.id
}

resource "aws_route_table_association" "hydra_rt_public_subnet_d" {
  subnet_id      = aws_subnet.hydra_public_subnet_d.id
  route_table_id = aws_route_table.hydra_rt.id
}

# ----------------------------------
# IAM
# ----------------------------------
data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "ecs_ssm" {
  name   = "ecs_ssm"
  policy = <<EOT
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ssmmessages:CreateControlChannel",
                "ssmmessages:CreateDataChannel",
                "ssmmessages:OpenControlChannel",
                "ssmmessages:OpenDataChannel"
            ],
            "Resource": "*"
        }
    ]
}
EOT
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "MyEcsTaskRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "amazon_ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "amazon_ecs_task_execution_role_policy2" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_ssm.arn
}

# ----------------------------------
# SecurityGroup
# ----------------------------------
resource "aws_security_group" "hydra_sg" {
  name        = "hydra_sg"
  description = "hydra_sg"

  vpc_id      = "${aws_vpc.hydra_vpc.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "hydra_sg"
  }
}

# ----------------------------------
# SecurityGroup Rule
# ----------------------------------
resource "aws_security_group_rule" "hydra_sg_rule_1" {
  security_group_id = "${aws_security_group.hydra_sg.id}"

  type = "ingress"

  from_port = 4444
  to_port   = 4444
  protocol  = "tcp"

  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "hydra_sg_rule_2" {
  security_group_id = "${aws_security_group.hydra_sg.id}"

  type = "ingress"

  from_port = 4445
  to_port   = 4445
  protocol  = "tcp"

  cidr_blocks = ["0.0.0.0/0"]
}

# ----------------------------------
# ELB Target Group
# ----------------------------------
resource "aws_lb_target_group" "hydra_lb_tg_1" {
  name = "hydra-lb-tg-1"

  vpc_id = "${aws_vpc.hydra_vpc.id}"

  port        = 4444
  protocol    = "TCP"
  target_type = "ip"
}

resource "aws_lb_target_group" "hydra_lb_tg_2" {
  name = "hydra-lb-tg-2"

  vpc_id = "${aws_vpc.hydra_vpc.id}"

  port        = 4445
  protocol    = "TCP"
  target_type = "ip"
}

# ----------------------------------
# ALB
# ----------------------------------
resource "aws_lb" "hydra_aws_lb" {
  load_balancer_type = "network"
  name               = "hydra-aws-lb"
  subnets            = ["${aws_subnet.hydra_public_subnet_a.id}","${aws_subnet.hydra_public_subnet_c.id}","${aws_subnet.hydra_public_subnet_d.id}"]
}

# ----------------------------------
# Listener
# ----------------------------------
resource "aws_lb_listener" "hydra_lb_listener_1" {
  port              = "4444"
  protocol          = "TCP"

  load_balancer_arn = "${aws_lb.hydra_aws_lb.arn}"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.hydra_lb_tg_1.arn
  }
}

resource "aws_lb_listener" "hydra_lb_listener_2" {
  port              = "4445"
  protocol          = "TCP"

  load_balancer_arn = "${aws_lb.hydra_aws_lb.arn}"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.hydra_lb_tg_2.arn
  }
}

#--------------------------------------------------------------
# rds cluster parameter group
#--------------------------------------------------------------
resource "aws_rds_cluster_parameter_group" "hydra_rds_cluster_parameter_group" {
  name   = "hydra-rds-cluster-parameter-group"
  family = "aurora-mysql8.0"

  parameter {
    name         = "character_set_client"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_connection"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_database"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_filesystem"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_results"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_server"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "collation_connection"
    value        = "utf8mb4_general_ci"
    apply_method = "immediate"
  }

  parameter {
    name         = "collation_server"
    value        = "utf8mb4_general_ci"
    apply_method = "immediate"
  }

  parameter {
    name         = "time_zone"
    value        = "Asia/Tokyo"
    apply_method = "immediate"
  }
}

#--------------------------------------------------------------
# RDS Security group
#--------------------------------------------------------------
resource "aws_security_group" "hydra_rds_sg" {
  name        = "hydra_rds_sg"
  description = "RDS service security"
  vpc_id      = aws_vpc.hydra_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "hydra_rds_sg"
  }
}

resource "aws_security_group_rule" "hydra_rds_sg_rule_1" {
  depends_on = [aws_security_group.hydra_rds_sg]
  security_group_id = "${aws_security_group.hydra_rds_sg.id}"

  type = "ingress"
  from_port = 0
  to_port   = 0
  protocol  = "-1"

  cidr_blocks = ["0.0.0.0/0"]
}

#--------------------------------------------------------------
# Subnet group
#--------------------------------------------------------------
resource "aws_db_subnet_group" "hydra_rds_subnet_group" {
  name        = "hydra_rds_subnet_group"
  description = "hydra_rds_subnet_group"
  subnet_ids  = ["${aws_subnet.hydra_private_subnet_a.id}","${aws_subnet.hydra_private_subnet_c.id}","${aws_subnet.hydra_private_subnet_d.id}"]
}

# ----------------------------------
# RDS
# ----------------------------------
resource "aws_rds_cluster" "hydra_db_cluster" {
  cluster_identifier = "hydra-db-cluster"
  engine             = "aurora-mysql"
  engine_version     = "8.0.mysql_aurora.3.01.0"
  master_username    = "hydra"
  master_password    = "hydra2022"
  port               = 3306
  database_name      = "hydra"

  vpc_security_group_ids = [aws_security_group.hydra_rds_sg.id]
  db_subnet_group_name = aws_db_subnet_group.hydra_rds_subnet_group.name
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.hydra_rds_cluster_parameter_group.name
  backup_retention_period = 15
  preferred_backup_window = "18:00-20:00"
  skip_final_snapshot = true
  apply_immediately   = true
}

resource "aws_rds_cluster_instance" "hydra_db_instance" {
  count = 1
  identifier             = "hydra-db-instance"
  cluster_identifier     = aws_rds_cluster.hydra_db_cluster.id
  engine                 = aws_rds_cluster.hydra_db_cluster.engine
  engine_version         = aws_rds_cluster.hydra_db_cluster.engine_version
  instance_class         = "db.t3.medium"
  publicly_accessible    = true
}

#
resource "null_resource" "db_setup" {
  triggers = {
    name = "db_setup"
  }
  depends_on = [
    aws_rds_cluster.hydra_db_cluster,
    aws_rds_cluster_instance.hydra_db_instance,
  ]

  provisioner "local-exec" {
    command = "mysql -h ${aws_rds_cluster.hydra_db_cluster.endpoint} -u ${aws_rds_cluster.hydra_db_cluster.master_username} -p${aws_rds_cluster.hydra_db_cluster.master_password} ${aws_rds_cluster.hydra_db_cluster.database_name} < ./aurora_create_db.sql"
  }
}

# ----------------------------------
# CloudWatch Logs
# ----------------------------------
resource "aws_cloudwatch_log_group" "hydra_ecs_task_definition" {
  name = "/ecs/hydra_ecs_task_definition"
}

# ----------------------------------
# ECS Cluster
# ----------------------------------
resource "aws_ecs_cluster" "hydra_ecs_cluster" {
  name = "hydra_ecs_cluster"
}

# ----------------------------------
# Task Definition
# ----------------------------------
resource "aws_ecs_task_definition" "hydra_ecs_task_definition" {
  family = "hydra_ecs_task_definition"

  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  requires_compatibilities = ["FARGATE"]

  cpu    = "256"
  memory = "512"

  network_mode = "awsvpc"

  container_definitions = <<EOL
[
  {
    "name": "hydra",
    "image": "616004226956.dkr.ecr.ap-northeast-1.amazonaws.com/hydra_no_env:latest",
    "portMappings": [
      {
        "containerPort": 4444,
        "hostPort": 4444
      },
      {
        "containerPort": 4445,
        "hostPort": 4445
      }
    ],
    "essential": true,
    "environment": [
      {
        "name": "DSN",
        "value": "mysql://${aws_rds_cluster.hydra_db_cluster.master_username}:${aws_rds_cluster.hydra_db_cluster.master_password}@tcp(${aws_rds_cluster.hydra_db_cluster.endpoint}:3306)/${aws_rds_cluster.hydra_db_cluster.database_name}?parseTime=true"
      },
      {
        "name": "ALB",
        "value": "${aws_lb.hydra_aws_lb.dns_name}"
      }
    ],
    "command" : ["serve","-c","/etc/config/hydra/hydra.yml","all","--dangerous-force-http"],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "ap-northeast-1",
        "awslogs-group": "/ecs/hydra_ecs_task_definition",
        "awslogs-stream-prefix": "ecs"
      }
    },
    "linuxParameters" : {
      "initProcessEnabled": true
    }
  }
]
EOL
}

# ----------------------------------
# ECS Service
# ----------------------------------
resource "aws_ecs_service" "hydra_ecs_service" {
  depends_on = [
    aws_rds_cluster.hydra_db_cluster,
    aws_rds_cluster_instance.hydra_db_instance,
    aws_ecs_task_definition.hydra_ecs_task_definition
  ]

  name = "hydra_ecs_service"
  cluster = "${aws_ecs_cluster.hydra_ecs_cluster.name}"
  launch_type = "FARGATE"
  desired_count = "1"
  task_definition = "${aws_ecs_task_definition.hydra_ecs_task_definition.arn}"
  health_check_grace_period_seconds = 60
  enable_execute_command = true

  network_configuration {
    subnets          = ["${aws_subnet.hydra_public_subnet_a.id}","${aws_subnet.hydra_public_subnet_c.id}","${aws_subnet.hydra_public_subnet_d.id}"]
    security_groups  = ["${aws_security_group.hydra_sg.id}"]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = "${aws_lb_target_group.hydra_lb_tg_1.arn}"
    container_name   = "hydra"
    container_port   = "4444"
  }

  load_balancer {
    target_group_arn = "${aws_lb_target_group.hydra_lb_tg_2.arn}"
    container_name   = "hydra"
    container_port   = "4445"
  }
}

# ----------------------------------
# S3
# ----------------------------------
resource "aws_s3_bucket" "api_facede_assets" {
  bucket = "api-facede-assets"
}

resource "aws_s3_bucket_acl" "api_facede_assets" {
  bucket = aws_s3_bucket.api_facede_assets.bucket
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "api_facede_assets" {
  bucket = aws_s3_bucket.api_facede_assets.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "api_facede_assets" {
  bucket = aws_s3_bucket.api_facede_assets.bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ----------------------------------
# Lambda IAM
# ----------------------------------
resource "aws_iam_role" "api_facede_iam" {
  name = "api_facede"

  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
EOF
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/SecretsManagerReadWrite",
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole",
  ]
}

# ----------------------------------
# Lambda コードZIP化
# ----------------------------------
resource "null_resource" "lambda_build" {
  depends_on = [aws_s3_bucket.api_facede_assets]

  triggers = {
    code_diff = join("", [
      for file in fileset(local.golang_codedir_local_path, "*.go")
      : filebase64("${local.golang_codedir_local_path}/${file}")
    ])
  }

  provisioner "local-exec" {
    command = "GOARCH=amd64 GOOS=linux go build -o ${local.golang_binary_local_path} ${local.golang_codedir_local_path}/*.go"
  }
  provisioner "local-exec" {
    command = "zip -j ${local.golang_zip_local_path} ${local.golang_binary_local_path}"
  }
  provisioner "local-exec" {
    command = "aws s3 cp ${local.golang_zip_local_path} s3://${aws_s3_bucket.api_facede_assets.bucket}/${local.golang_zip_s3_key}"
  }
  provisioner "local-exec" {
    command = "openssl dgst -sha256 -binary ${local.golang_zip_local_path} | openssl enc -base64 | tr -d \"\n\" > ${local.golang_zip_base64sha256_local_path}"
  }
  provisioner "local-exec" {
    command = "aws s3 cp ${local.golang_zip_base64sha256_local_path} s3://${aws_s3_bucket.api_facede_assets.bucket}/${local.golang_zip_base64sha256_s3_key} --content-type \"text/plain\""
  }
}

# ----------------------------------
# go zip
# ----------------------------------
data "aws_s3_object" "golang_zip" {
  depends_on = [null_resource.lambda_build]

  bucket = aws_s3_bucket.api_facede_assets.bucket
  key    = local.golang_zip_s3_key
}

data "aws_s3_object" "golang_zip_hash" {
  depends_on = [null_resource.lambda_build]

  bucket = aws_s3_bucket.api_facede_assets.bucket
  key    = local.golang_zip_base64sha256_s3_key
}

# ----------------------------------
# Secrets Manager
# ----------------------------------
resource "aws_secretsmanager_secret" "hydra_rds5" {
  name = "hydra_rds5"
}

resource "aws_secretsmanager_secret_version" "hydra_rds" {
  secret_id     = aws_secretsmanager_secret.hydra_rds5.id
  secret_string = jsonencode(
    {
      "username" = aws_rds_cluster.hydra_db_cluster.master_username,
      "password" = aws_rds_cluster.hydra_db_cluster.master_password,
      "engine" = "mysql",
      "host" = aws_rds_cluster.hydra_db_cluster.endpoint,
      "port" = aws_rds_cluster.hydra_db_cluster.port,
      "dbClusterIdentifier" = aws_rds_cluster.hydra_db_cluster.cluster_identifier
    }
  )
  lifecycle {
    ignore_changes = [
      secret_string
    ]
  }
}

# ----------------------------------
# データベースプロキシ IAMロール
# ----------------------------------
data "aws_iam_policy_document" "hydra_rds_seacret_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "hydra_rds_seacret" {
  name   = "hydra_rds_seacret"
  policy = jsonencode(
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "VisualEditor0",
                "Effect": "Allow",
                "Action": [
                    "secretsmanager:GetResourcePolicy",
                    "secretsmanager:GetSecretValue",
                    "secretsmanager:DescribeSecret",
                    "secretsmanager:ListSecretVersionIds"
                ],
                "Resource": [
                    aws_secretsmanager_secret.hydra_rds5.arn
                ]
            }
        ]
    }
  )
}

resource "aws_iam_role" "hydra_rds_seacret" {
  name               = "hydra_rds_seacret"
  assume_role_policy = data.aws_iam_policy_document.hydra_rds_seacret_assume_role.json
}

resource "aws_iam_role_policy_attachment" "proxy_execution_role_policy" {
  role       = aws_iam_role.hydra_rds_seacret.name
  policy_arn = aws_iam_policy.hydra_rds_seacret.arn
}

#--------------------------------------------------------------
# データベースプロキシ Security group
#--------------------------------------------------------------
resource "aws_security_group" "hydra_rds_proxy_sg" {
  name        = "hydra_rds_proxy_sg"
  description = "hydra_rds_proxy_sg"
  vpc_id      = aws_vpc.hydra_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "hydra_rds_proxy_sg"
  }
}

# ----------------------------------
# データベースプロキシ
# ----------------------------------
resource "aws_db_proxy" "hydra_rds_proxy" {
  name                   = "hydra-rds-proxy"
  debug_logging          = false
  engine_family          = "MYSQL"
  idle_client_timeout    = 1800
  require_tls            = false
  role_arn               = aws_iam_role.hydra_rds_seacret.arn
  vpc_security_group_ids = [aws_security_group.hydra_rds_proxy_sg.id]
  vpc_subnet_ids = [aws_subnet.hydra_private_subnet_a.id,aws_subnet.hydra_private_subnet_c.id,aws_subnet.hydra_private_subnet_d.id]

  auth {
    auth_scheme = "SECRETS"
    iam_auth    = "DISABLED"
    secret_arn  = aws_secretsmanager_secret.hydra_rds5.arn
  }

  depends_on = [aws_rds_cluster.hydra_db_cluster, aws_secretsmanager_secret_version.hydra_rds]
}

resource "aws_db_proxy_default_target_group" "hydra_rds_proxy" {
  db_proxy_name = aws_db_proxy.hydra_rds_proxy.name
}

resource "aws_db_proxy_target" "hydra_rds_proxy" {
  db_cluster_identifier = aws_rds_cluster.hydra_db_cluster.id
  db_proxy_name = aws_db_proxy.hydra_rds_proxy.name
  target_group_name = "default"
}

# ----------------------------------
# SecurityGroup
# ----------------------------------
resource "aws_iam_role_policy" "api_facede_proxy_iam" {
  name = "api_facede_proxy_iam"
  role = aws_iam_role.api_facede_iam.id

  policy = jsonencode({
      "Version": "2012-10-17",
      "Statement": [
          {
              "Effect": "Allow",
              "Action": "rds-db:connect",
              "Resource": "arn:aws:rds-db:ap-northeast-1:616004226956:dbuser:${aws_db_proxy.hydra_rds_proxy.endpoint}/*"
          }
      ]
  })
}

# ----------------------------------
# SecurityGroup
# ----------------------------------
resource "aws_security_group" "api_facede_sg" {
  name        = "api_facede_sg"
  description = "api_facede_sg"

  vpc_id      = "${aws_vpc.hydra_vpc.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "api_facede_sg"
  }
}

# ----------------------------------
# SecurityGroup Rule
# ----------------------------------
resource "aws_security_group_rule" "api_facede_sg" {
  depends_on = [aws_security_group.api_facede_sg]
  security_group_id = "${aws_security_group.api_facede_sg.id}"

  type = "ingress"

  from_port = 0
  to_port   = 65535
  protocol  = "tcp"

  cidr_blocks = ["10.0.0.0/16"]
}

# ----------------------------------
# RDS SecurityGroup Rule
# ----------------------------------
resource "aws_security_group_rule" "hydra_rds_sg_rule_2" {
  depends_on = [
    aws_security_group_rule.hydra_rds_proxy_sg,
    aws_security_group.hydra_rds_sg,
    aws_security_group_rule.hydra_rds_sg_rule_1
  ]
  security_group_id = aws_security_group.hydra_rds_sg.id
  type = "ingress"
  from_port = 3306
  to_port   = 3306
  protocol  = "tcp"
  source_security_group_id = aws_security_group.hydra_rds_proxy_sg.id
}

# ----------------------------------
# データベースプロキシ SecurityGroup Rule
# ----------------------------------
resource "aws_security_group_rule" "hydra_rds_proxy_sg" {
  depends_on = [aws_security_group.hydra_rds_proxy_sg]
  security_group_id = aws_security_group.hydra_rds_proxy_sg.id
  type = "ingress"
  from_port = 3306
  to_port   = 3306
  protocol  = "tcp"
  source_security_group_id = aws_security_group.api_facede_sg.id
}

# ----------------------------------
# Lambda
# ----------------------------------
resource "aws_lambda_function" "api_facede" {
  depends_on = [
    null_resource.lambda_build,
    data.aws_s3_object.golang_zip,
    data.aws_s3_object.golang_zip_hash,
    aws_security_group_rule.api_facede_sg,
    aws_iam_role.api_facede_iam,
    aws_db_proxy_target.hydra_rds_proxy
  ]
  function_name    = "api_facede"
  s3_bucket        = aws_s3_bucket.api_facede_assets.bucket
  s3_key           = data.aws_s3_object.golang_zip.key
  role             = aws_iam_role.api_facede_iam.arn
  handler          = "api_facede"
  source_code_hash = data.aws_s3_object.golang_zip_hash.body
  runtime          = "go1.x"
  timeout          = "10"
  vpc_config {
    subnet_ids         = [
      aws_subnet.api_facede_subnet_a.id,
      aws_subnet.api_facede_subnet_c.id,
      aws_subnet.api_facede_subnet_d.id
    ]
    security_group_ids = [aws_security_group.api_facede_sg.id]
  }
}

# ----------------------------------
# API GATEWAY
# ----------------------------------
resource "aws_api_gateway_rest_api" "api_facede" {
  name        = "api_facede"
  description = "api_facede API Gateway"
}

resource "aws_api_gateway_resource" "api_facede" {
  rest_api_id = aws_api_gateway_rest_api.api_facede.id
  parent_id   = aws_api_gateway_rest_api.api_facede.root_resource_id
  path_part   = "api_facede"
}

resource "aws_api_gateway_method" "api_facede" {
  rest_api_id      = aws_api_gateway_rest_api.api_facede.id
  resource_id      = aws_api_gateway_resource.api_facede.id
  http_method      = "GET"
  authorization    = "NONE"
  api_key_required = false
}

resource "aws_api_gateway_method_response" "api_facede" {
  rest_api_id = aws_api_gateway_rest_api.api_facede.id
  resource_id = aws_api_gateway_resource.api_facede.id
  http_method = aws_api_gateway_method.api_facede.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  depends_on = [aws_api_gateway_method.api_facede]
}

resource "aws_api_gateway_integration" "api_facede" {
  rest_api_id             = aws_api_gateway_rest_api.api_facede.id
  resource_id             = aws_api_gateway_resource.api_facede.id
  http_method             = aws_api_gateway_method.api_facede.http_method
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.api_facede.invoke_arn
}

# ----------------------------------
# API Gatewayのステージ及びデプロイを定義
# ----------------------------------
resource "aws_api_gateway_deployment" "api_facede" {
  rest_api_id       = aws_api_gateway_rest_api.api_facede.id
  stage_name        = "api_facede"
  stage_description = "timestamp = ${timestamp()}"

  depends_on = [
    aws_api_gateway_integration.api_facede
  ]

  lifecycle {
    create_before_destroy = true
  }
}

# ----------------------------------
# API GatewayにLambda関数へのアクセスを許可
# ----------------------------------
resource "aws_lambda_permission" "api_facede" {
   statement_id  = "AllowExecutionFromAPIGateway"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.api_facede.function_name
   principal     = "apigateway.amazonaws.com"
   source_arn    = "${aws_api_gateway_rest_api.api_facede.execution_arn}/*/${aws_api_gateway_method.api_facede.http_method}/${aws_api_gateway_resource.api_facede.path_part}"
}
