resource "aws_security_group" "allow-http" {
  name        = "allow-http"
  description = "Allow HTTP and SSH traffic"

  tags = {
    Name = "allow_http_and_ssh"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow-http-ingress" {
  security_group_id = aws_security_group.allow-http.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow-ssh-ingress" {
  security_group_id = aws_security_group.allow-http.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_security_group_rule" "allow-outbound-traffic-egress" {
  type        = "egress"
  security_group_id = aws_security_group.allow-http.id
  cidr_blocks = ["0.0.0.0/0"]
  from_port   = 0
  to_port     = 0
  protocol    = "-1" # All protocols
}