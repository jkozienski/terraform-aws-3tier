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
      Name        = "${var.environment}-vpc"
      Environment = var.environment
    },
    var.tags,
  )

}

# Public subnets #
resource "aws_subnet" "public" {
  count                   = length(var.subnet_public)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.subnet_public[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name        = "${var.environment}-public-${count.index + 1}"
      Environment = var.environment
      Tier = "public"
    },
    var.tags,
  )
}

# Private subnets #
resource "aws_subnet" "private" {
  count                   = length(var.subnet_private)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.subnet_private[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = merge(
    {
      Name        = "${var.environment}-private-${count.index + 1}"
      Environment = var.environment
      Tier = "private"
    },
    var.tags,
  )
}

# Internet Gateway #
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      Name        = "${var.environment}-internet-gateway"
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
  subnet_id     = aws_subnet.public[0].id  
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
resource "aws_route_table" "public_web" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      Name        = "${var.environment}-public-web-route-table"
      Environment = var.environment
    },
    var.tags,
  )
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public_web.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  count          = length(var.subnet_public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_web.id
}

resource "aws_route_table" "private_app" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      Name        = "${var.environment}-private-app-route-table"
      Environment = var.environment
    },
    var.tags,
  )
}

resource "aws_route" "private_app_outbound" {
  route_table_id         = aws_route_table.private_app.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this.id
}

resource "aws_route_table_association" "private_app" {
  subnet_id      = aws_subnet.private[0].id
  route_table_id = aws_route_table.private_app.id
}


resource "aws_route_table" "private_db" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      Name        = "${var.environment}-private-db-route-table"
      Environment = var.environment
    },
    var.tags,
  )
}

resource "aws_route" "private_db_outbound" {
  route_table_id         = aws_route_table.private_db.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this.id
}

resource "aws_route_table_association" "private_db" {
  subnet_id      = aws_subnet.private[1].id
  route_table_id = aws_route_table.private_db.id
}