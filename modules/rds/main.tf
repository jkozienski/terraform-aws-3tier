# DB Subnet Group #
resource "aws_db_subnet_group" "this" {
  name       = "${var.project}-${var.environment}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(
    {
      Name        = "${var.project}-${var.environment}-db-subnet-group"
      Project     = var.project
      Environment = var.environment
    },
    var.tags,
  )
}

# RDS Instance #
resource "aws_db_instance" "this" {
  identifier = "${var.project}-${var.environment}-db"

  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  db_name           = var.db_name
  username          = var.username
  password          = var.password

  allocated_storage      = var.allocated_storage
  max_allocated_storage  = var.max_allocated_storage
  storage_type           = "gp2"
  storage_encrypted      = true

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.db_sg_id]

  publicly_accessible = var.publicly_accessible
  multi_az            = var.multi_az

  performance_insights_enabled = false
  skip_final_snapshot     = true            
  deletion_protection     = var.deletion_protection

  auto_minor_version_upgrade = true
  copy_tags_to_snapshot      = true

  tags = merge(
    {
      Name        = "${var.project}-${var.environment}-db"
      Project     = var.project
      Environment = var.environment
    },
    var.tags,
  )
}
