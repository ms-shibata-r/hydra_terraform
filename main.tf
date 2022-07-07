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

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "MyEcsTaskRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "amazon_ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ----------------------------------
# SecurityGroup
# ----------------------------------
resource "aws_security_group" "hydra_sg_terraform" {
  name        = "hydra_sg_terraform"
  description = "hydra_sg_terraform"

  vpc_id      = "${aws_vpc.hydra_vpc.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "hydra_sg_terraform"
  }
}

# ----------------------------------
# SecurityGroup Rule
# ----------------------------------
resource "aws_security_group_rule" "hydra_sg_rule_terraform_1" {
  security_group_id = "${aws_security_group.hydra_sg_terraform.id}"

  type = "ingress"

  from_port = 4444
  to_port   = 4444
  protocol  = "tcp"

  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "hydra_sg_rule_terraform_2" {
  security_group_id = "${aws_security_group.hydra_sg_terraform.id}"

  type = "ingress"

  from_port = 4445
  to_port   = 4445
  protocol  = "tcp"

  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "hydra_sg_rule_terraform_3" {
  security_group_id = "${aws_security_group.hydra_sg_terraform.id}"

  type = "ingress"

  from_port = 5555
  to_port   = 5555
  protocol  = "tcp"

  cidr_blocks = ["0.0.0.0/0"]
}

# ----------------------------------
# ELB Target Group
# ----------------------------------
resource "aws_lb_target_group" "hydra_lb_tg_terraform_1" {
  name = "hydra-lb-tg-terraform-1"

  vpc_id = "${aws_vpc.hydra_vpc.id}"

  port        = 4444
  protocol    = "TCP"
  target_type = "ip"
}

resource "aws_lb_target_group" "hydra_lb_tg_terraform_2" {
  name = "hydra-lb-tg-terraform-2"

  vpc_id = "${aws_vpc.hydra_vpc.id}"

  port        = 4445
  protocol    = "TCP"
  target_type = "ip"
}

resource "aws_lb_target_group" "hydra_lb_tg_terraform_3" {
  name = "hydra-lb-tg-terraform-3"

  vpc_id = "${aws_vpc.hydra_vpc.id}"

  port        = 5555
  protocol    = "TCP"
  target_type = "ip"
}

# ----------------------------------
# ALB
# ----------------------------------
resource "aws_lb" "hydra_aws_lb_terraform" {
  load_balancer_type = "network"
  name               = "hydra-aws-lb-terraform"
  subnets         = ["${aws_subnet.hydra_public_subnet_a.id}","${aws_subnet.hydra_public_subnet_c.id}","${aws_subnet.hydra_public_subnet_d.id}"]
}

# ----------------------------------
# Listener
# ----------------------------------
resource "aws_lb_listener" "hydra_lb_listener_terraform_1" {
  port              = "4444"
  protocol          = "TCP"

  load_balancer_arn = "${aws_lb.hydra_aws_lb_terraform.arn}"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.hydra_lb_tg_terraform_1.arn
  }
}

resource "aws_lb_listener" "hydra_lb_listener_terraform_2" {
  port              = "4445"
  protocol          = "TCP"

  load_balancer_arn = "${aws_lb.hydra_aws_lb_terraform.arn}"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.hydra_lb_tg_terraform_2.arn
  }
}

resource "aws_lb_listener" "hydra_lb_listener_terraform_3" {
  port              = "5555"
  protocol          = "TCP"

  load_balancer_arn = "${aws_lb.hydra_aws_lb_terraform.arn}"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.hydra_lb_tg_terraform_3.arn
  }
}

#--------------------------------------------------------------
# rds cluster parameter group
#--------------------------------------------------------------
resource "aws_rds_cluster_parameter_group" "hydra_rds_cluster_parameter_group_terraform" {
  name   = "hydra-rds-cluster-parameter-group-terraform"
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
resource "aws_security_group" "hydra_rds_sg_terraform" {
  name        = "hydra_rds_sg_terraform"
  description = "RDS service security"
  vpc_id      = aws_vpc.hydra_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "hydra_rds_sg_terraform"
  }
}

#--------------------------------------------------------------
# Subnet group
#--------------------------------------------------------------
resource "aws_db_subnet_group" "hydra_rds_subnet_group_terraform" {
  name        = "hydra_rds_subnet_group_terraform"
  description = "hydra_rds_subnet_group_terraform"
  subnet_ids  = ["${aws_subnet.hydra_private_subnet_a.id}","${aws_subnet.hydra_private_subnet_c.id}","${aws_subnet.hydra_private_subnet_d.id}"]
}

# ----------------------------------
# RDS
# ----------------------------------
resource "aws_rds_cluster" "hydra_db_cluster_mysql80_terraform" {
  cluster_identifier = "hydra-db-cluster-mysql80-terraform"
  engine         = "aurora-mysql"
  engine_version = "8.0.mysql_aurora.3.01.0"
  master_username = "hydra"
  master_password = "hydra2022"
  port            = 3306
  database_name   = "hydra"

  vpc_security_group_ids = [aws_security_group.hydra_rds_sg_terraform.id]
  db_subnet_group_name = aws_db_subnet_group.hydra_rds_subnet_group_terraform.name
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.hydra_rds_cluster_parameter_group_terraform.name

  backup_retention_period = 15
  preferred_backup_window = "18:00-20:00"

  skip_final_snapshot = true
  apply_immediately   = true
}

resource "aws_rds_cluster_instance" "hydra_db_instance_terraform" {
  count = 1
  identifier             = "hydra-db-instance-terraform"
  cluster_identifier     = aws_rds_cluster.hydra_db_cluster_mysql80_terraform.id
  engine                 = aws_rds_cluster.hydra_db_cluster_mysql80_terraform.engine
  engine_version         = aws_rds_cluster.hydra_db_cluster_mysql80_terraform.engine_version
  instance_class         = "db.t3.medium"
  publicly_accessible    = true
}

#
resource "null_resource" "db_setup" {
  triggers = {
    name = "db_setup"
  }
  depends_on = [
    aws_rds_cluster.hydra_db_cluster_mysql80_terraform,
    aws_rds_cluster_instance.hydra_db_instance_terraform,
  ]

  provisioner "local-exec" {
    command = "mysql -h hydra-db-cluster-mysql80-terraform.cluster-ro-cggh3018flmj.ap-northeast-1.rds.amazonaws.com -u hydra -phydra2022 hydra < ./aurora_create_db.sql"
  }
}

# ----------------------------------
# ECS Cluster
# ----------------------------------
resource "aws_ecs_cluster" "hydra_ecs_cluster_terraform" {
  name = "hydra_ecs_cluster_terraform"
}

# ----------------------------------
# Task Definition
# ----------------------------------
resource "aws_ecs_task_definition" "hydra_ecs_task_definition_terraform" {
  family = "hydra_ecs_task_definition_terraform"

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
      },
      {
        "containerPort": 5555,
        "hostPort": 5555
      }
    ],
    "essential": true,
    "environment": [
      {
        "name": "DSN",
        "value": "mysql://${aws_rds_cluster.hydra_db_cluster_mysql80_terraform.master_username}:${aws_rds_cluster.hydra_db_cluster_mysql80_terraform.master_password}@tcp(hydra-db-cluster-mysql80-terraform.cluster-ro-cggh3018flmj.ap-northeast-1.rds.amazonaws.com:3306)/${aws_rds_cluster.hydra_db_cluster_mysql80_terraform.database_name}?parseTime=true"
      }
    ],
    "command" : ["serve","-c","/etc/config/hydra/hydra.yml","all","--dangerous-force-http"],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "ap-northeast-1",
        "awslogs-group": "/ecs/hydra_ecs_task_definition_terraform",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]
EOL
}

# ----------------------------------
# ECS Service
# ----------------------------------
resource "aws_ecs_service" "hydra_ecs_service_terraform" {
  depends_on = [
    aws_rds_cluster.hydra_db_cluster_mysql80_terraform,
    aws_rds_cluster_instance.hydra_db_instance_terraform,
    aws_ecs_task_definition.hydra_ecs_task_definition_terraform
  ]

  name = "hydra_ecs_service_terraform"

  cluster = "${aws_ecs_cluster.hydra_ecs_cluster_terraform.name}"

  launch_type = "FARGATE"

  desired_count = "1"

  task_definition = "${aws_ecs_task_definition.hydra_ecs_task_definition_terraform.arn}"

  network_configuration {
    subnets         = ["${aws_subnet.hydra_public_subnet_a.id}","${aws_subnet.hydra_public_subnet_c.id}","${aws_subnet.hydra_public_subnet_d.id}"]
    security_groups = ["${aws_security_group.hydra_sg_terraform.id}"]
    assign_public_ip = true
  }

  load_balancer {
      target_group_arn = "${aws_lb_target_group.hydra_lb_tg_terraform_1.arn}"
      container_name   = "hydra"
      container_port   = "4444"
  }

  load_balancer {
      target_group_arn = "${aws_lb_target_group.hydra_lb_tg_terraform_2.arn}"
      container_name   = "hydra"
      container_port   = "4445"
  }

  load_balancer {
      target_group_arn = "${aws_lb_target_group.hydra_lb_tg_terraform_3.arn}"
      container_name   = "hydra"
      container_port   = "5555"
  }
}
