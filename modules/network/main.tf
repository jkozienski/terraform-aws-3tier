data "aws_availability_zones" "available" {
  state = "available"
}

# VPC #
resource "aws_vpc" "this" {
  cidr_block = var.cidr_block

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    {
      Name        = "todolist-${var.environment}-vpc"
      Environment = var.environment
    },
    var.tags,
  )

}

# Public subnets for ALB #
resource "aws_subnet" "alb_public" {
  count                   = length(var.alb_subnet_public)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.alb_subnet_public[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name        = "${var.environment}-alb-public-${count.index + 1}"
      Environment = var.environment
      Tier        = "alb-public"
    },
    var.tags,
  )
}

# Private subnets - Frontend tier #
resource "aws_subnet" "frontend" {
  count                   = length(var.frontend_subnet_private)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.frontend_subnet_private[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = merge(
    {
      Name        = "${var.environment}-frontend-${count.index + 1}"
      Environment = var.environment
      Tier        = "frontend"
    },
    var.tags,
  )
}

# Private subnets - Backend tier #
resource "aws_subnet" "backend" {
  count                   = length(var.backend_subnet_private)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.backend_subnet_private[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = merge(
    {
      Name        = "${var.environment}-backend-${count.index + 1}"
      Environment = var.environment
      Tier        = "backend"
    },
    var.tags,
  )
}

# Private subnets - Database tier #
resource "aws_subnet" "db" {
  count                   = length(var.db_subnet_private)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.db_subnet_private[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = merge(
    {
      Name        = "${var.environment}-db-${count.index + 1}"
      Environment = var.environment
      Tier        = "db"
    },
    var.tags,
  )
}

# Internet Gateway #
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      Name        = "${var.environment}-igw"
      Environment = var.environment
    },
    var.tags,
  )
}

# NAT Gateway #
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = merge(
    {
      Name        = "${var.environment}-nat-eip"
      Environment = var.environment
    },
    var.tags,
  )
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.alb_public[0].id  
  tags = merge(
    {
      Name        = "${var.environment}-nat-gateway"
      Environment = var.environment
    },
    var.tags,
  )

  depends_on = [aws_internet_gateway.this]
}

# Route Tables #
resource "aws_route_table" "alb_public" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      Name        = "${var.environment}-alb-public-route-table"
      Environment = var.environment
    },
    var.tags,
  )
}

resource "aws_route" "alb_public_internet_access" {
  route_table_id         = aws_route_table.alb_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "alb_public" {
  count          = length(var.alb_subnet_public)
  subnet_id      = aws_subnet.alb_public[count.index].id
  route_table_id = aws_route_table.alb_public.id
}

resource "aws_route_table" "frontend" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      Name        = "${var.environment}-frontend-route-table"
      Environment = var.environment
    },
    var.tags,
  )
}

resource "aws_route" "frontend_outbound" {
  route_table_id         = aws_route_table.frontend.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this.id
}

resource "aws_route_table_association" "frontend" {
  count          = length(var.frontend_subnet_private)
  subnet_id      = aws_subnet.frontend[count.index].id
  route_table_id = aws_route_table.frontend.id
}

resource "aws_route_table" "backend" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      Name        = "${var.environment}-backend-route-table"
      Environment = var.environment
    },
    var.tags,
  )
}

resource "aws_route" "backend_outbound" {
  route_table_id         = aws_route_table.backend.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this.id
}

resource "aws_route_table_association" "backend" {
  count          = length(var.backend_subnet_private)
  subnet_id      = aws_subnet.backend[count.index].id
  route_table_id = aws_route_table.backend.id
}

resource "aws_route_table" "db" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      Name        = "${var.environment}-db-route-table"
      Environment = var.environment
    },
    var.tags,
  )
}

resource "aws_route" "db_outbound" {
  route_table_id         = aws_route_table.db.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this.id
}

resource "aws_route_table_association" "db" {
  count          = length(var.db_subnet_private)
  subnet_id      = aws_subnet.db[count.index].id
  route_table_id = aws_route_table.db.id
}
