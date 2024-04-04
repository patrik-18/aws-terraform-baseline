resource "aws_route_table" "example_route_table" {
  vpc_id = var.vpc_id

  # Define your routes here
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.gateway_id
  }

  tags = {
    Name = var.name
  }
}

resource "aws_route_table_association" "example_rtb_assoc" {
  count           = length(var.subnet_ids)
  subnet_id       = var.subnet_ids[count.index]
  route_table_id  = aws_route_table.example_route_table.id
}

output "id" {
  description = "id"
  value       = aws_route_table.example_route_table.id
}