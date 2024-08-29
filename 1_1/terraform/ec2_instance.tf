resource "aws_instance" "flask_app" {
  ami           = "ami-0e872aee57663ae2d"
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  vpc_security_group_ids = [aws_security_group.allow-http.id]
  key_name = "test2"
  user_data = file("userdata.sh")

  tags = {
    Name = "flask-app"
  }
}