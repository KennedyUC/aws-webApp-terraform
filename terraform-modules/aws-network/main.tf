resource "aws_vpc" "vpc" {
  cidr_block            = var.vpc_cidr
  enable_dns_hostnames  = var.enable_vpc_dns

  tags = {
    Name = "${var.project_name}-${var.env}-vpc"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public_subnets" {
  count = var.subnet_count

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, var.subnet_bits, count.index)
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true

  depends_on = [aws_vpc.vpc]

  tags = {
    Name = "${var.project_name}-${var.env}-public-subnet"
  }
}

resource "aws_subnet" "private_subnets" {
  count = var.subnet_count

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, var.subnet_bits, count.index + var.subnet_count)
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = false

  depends_on = [aws_vpc.vpc]

  tags = {
    Name = "${var.project_name}-${var.env}-private-subnet"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  depends_on = [aws_subnet.public_subnets, aws_subnet.private_subnets]

  tags = {
    Name = "${var.project_name}-${var.env}-internet-gateway"
  }
}

resource "aws_internet_gateway_attachment" "InternetGatewayAttachment" {
  internet_gateway_id = aws_internet_gateway.internet_gateway.id
  vpc_id              = aws_vpc.vpc.id

  depends_on = [aws_internet_gateway.internet_gateway]
}

resource "aws_eip" "nat_eip" {
  domain   = "vpc"

  depends_on = [aws_internet_gateway_attachment.InternetGatewayAttachment]

  tags = {
    Name = "${var.project_name}-${var.env}-nat-eip"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnets[0].id

  depends_on = [aws_eip.nat_eip]

  tags = {
    Name = "${var.project_name}-${var.env}-nat-gw"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  depends_on = [aws_nat_gateway.nat_gateway]

  tags = {
    Name = "${var.project_name}-${var.env}-route-table"
  }
}

resource "aws_route_table_association" "public_route_association" {
  count          = var.subnet_count
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id

  depends_on = [aws_route_table.public_route_table]
}

resource "aws_route" "public_internet_route" {
  route_table_id         = aws_route_table.public_route_table.id
  gateway_id             = aws_internet_gateway.internet_gateway.id
  destination_cidr_block = "0.0.0.0/0"

  depends_on = [aws_route_table_association.public_route_association]
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  depends_on = [aws_route.public_internet_route]

  tags = {
    Name = "${var.project_name}-${var.env}-route-table"
  }
}

resource "aws_route_table_association" "private_route_association" {
  count          = var.subnet_count
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_table.id

  depends_on = [aws_route_table.private_route_table]
}

resource "aws_route" "private_internet_route" {
  route_table_id         = aws_route_table.private_route_table.id
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
  destination_cidr_block = "0.0.0.0/0"

  depends_on = [aws_route_table_association.private_route_association]
}

resource "aws_security_group" "security_group" {
  name   =  "${var.project_name}-${var.env}-security-group"
  vpc_id = aws_vpc.vpc.id
  description = "Allow TLS inbound and outbound traffics"

  ingress = [{
    description      = "Allow HTTPS"
    protocol         = "tcp"
    from_port        = 443
    to_port          = 443
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = null
    prefix_list_ids  = []
    security_groups  = []
    self             = false
    },
    {
    description      = "Allow HTTP"
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = null
    prefix_list_ids  = []
    security_groups  = []
    self             = false
    },
    {
    description      = "Allow Postgres"
    protocol         = "tcp"
    from_port        = 5432
    to_port          = 5432
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = null
    prefix_list_ids  = []
    security_groups  = []
    self             = false
    }
  ]

  egress = [
    {
    description      = "Allow all outbound traffic"
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids  = []
    security_groups  = []
    self             = false
    }
  ]

  depends_on = [aws_route.private_internet_route]

  tags = {
    Name = "Allow TLS for ${var.project_name}-${var.env}"
  }
}