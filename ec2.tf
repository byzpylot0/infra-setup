resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"  # Replace with your desired AMI
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public[0].id
  security_groups = [aws_security_group.web_sg.id]

  tags = {
    Name = "web-server"
  }
}
