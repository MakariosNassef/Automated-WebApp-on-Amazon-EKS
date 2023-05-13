resource "aws_vpc" "main" {
  cidr_block = var.MAIN_VPC_CIDR_BLOCK
  tags = {
    Name = var.MAIN_VPC
  }
}

# to communication between VPC and the internet.
resource "aws_internet_gateway" "igw_main" {
  # The VPC ID to create in.
  vpc_id = aws_vpc.main.id

  #A map of tags to assign to the resource.
  tags = {
    Name = var.IGW_NAME
  }
}

resource "aws_subnet" "private_us_east_1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.PRIVATE_SUBNET_CIDR_BLOCK
  availability_zone = var.AVAILABILITY_ZONE_A

  tags = {
    "Name" = var.PRIVATE_SUBNET_NAME
    # set to the value "1", which mean that this Elastic Load Balancer is intended for internal use only within the cluster. 
    "kubernetes.io/role/internal-elb" = "1"
    # set to "owned", which indicate that the cluster named "demo" owns this resource.
    "kubernetes.io/cluster/eks" = "owned"
  }
}

resource "aws_subnet" "public_us_east_2a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.PUBLIC_SUBNET_CIDR_BLOCK_2
  availability_zone       = var.AVAILABILITY_ZONE_A
  map_public_ip_on_launch = true

  tags = {
    "Name" = var.PUBLIC_SUBNET_NAME_2
    # to Ensure VPC subnets have the proper tags to be discoverable by Kubernetes
    "kubernetes.io/role/elb"    = "1"
    "kubernetes.io/cluster/eks" = "shared"
  }
}

resource "aws_nat_gateway" "nat_gw2" {
  allocation_id = aws_eip.nat2.id
  subnet_id     = aws_subnet.public_us_east_2a.id

  tags = {
    Name = "gw NAT2"
  }
  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw_main]
}


resource "aws_subnet" "public_us_east_1b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.PUBLIC_SUBNET_CIDR_BLOCK
  availability_zone       = var.AVAILABILITY_ZONE_B
  map_public_ip_on_launch = true

  tags = {
    "Name" = var.PUBLIC_SUBNET_NAME
    # Ensure VPC subnets have the proper tags to be discoverable by Kubernetes
    "kubernetes.io/role/elb"    = "1"
    "kubernetes.io/cluster/eks" = "shared"
  }
}

# used 2 nat to make it high available
resource "aws_eip" "nat1" {
  depends_on = [aws_internet_gateway.igw_main]
}

resource "aws_eip" "nat2" {
  depends_on = [aws_internet_gateway.igw_main]
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat1.id
  subnet_id     = aws_subnet.public_us_east_1b.id

  tags = {
    Name = var.NAT_NAME
  }
  depends_on = [aws_internet_gateway.igw_main]
}

# create 2 route table 1 for private subnet and 1 is public route table 
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.PUBLIC_ROUTE_CIDER
    gateway_id = aws_internet_gateway.igw_main.id
  }

  tags = {
    Name = var.PUBLIC_ROUTE_NAME
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = var.PRIVATE_ROUTE_CIDER
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = var.PRIVATE_ROUTE_NAME
  }
}

resource "aws_route_table_association" "private_route_1a" {
  subnet_id      = aws_subnet.private_us_east_1a.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "public_route_1a" {
  subnet_id      = aws_subnet.public_us_east_1b.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_route_1b" {
  subnet_id      = aws_subnet.public_us_east_2a.id
  route_table_id = aws_route_table.public_route_table.id
}