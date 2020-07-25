# public subnets
# each subnet in a different AZ

resource "aws_subnet" "public" {
    count                   = length(var.availability_zones)
    vpc_id                  = aws_vpc.main.id
    cidr_block              = cidrsubnet(var.cidr_block,8, count.index)
    availability_zone       = element(var.availability_zones, count.index)
    map_public_ip_on_launch = true

    tags = {
        "Name" = "Public subnet - element(var.availability_zones, count.index)"
    }

}

# private subnets
# each subnet in a different AZ

resource "aws_subnet" "private" {
    count                   = length(var.availability_zones)
    vpc_id                  = aws_vpc.main.id

    # take into account cidr blocks allocated to the public subnets
    cidr_block              = cidrsubnet(var.cidr_block,8, count.index + length(var.availability_zones) )
    availability_zone       = element(var.availability_zones, count.index)
    map_public_ip_on_launch = false

    tags = {
        "Name" = "Private subnet - element(var.availability_zones, count.index)"
    }

}

# 
# NAT Gaewaysenable instances in a private subnet
# to connect to the internet or other AWS services,
# but prevent the internet from initiating
# a connection with those instances.
#
# we create a separate NAT Gateway in each AZ
# for high availability.
#
# Each NAT Gateway requires an Elastic IP.
#
resource "aws_eip" "nat" {
    count = length(var.availability_zones)
    vpc   = true
}

resource "aws_nat_gateway" "main" {
    count           = length(var.availability_zones)
    subnet_id       = element(aws_subnet.public.*.id, count.index)
    allocation_id   = element(aws_eip.nat.*.id, count.index)

    tags = {
        "Name"      = "NAT - element(var.availability_zones, count.index)"
    }

}
