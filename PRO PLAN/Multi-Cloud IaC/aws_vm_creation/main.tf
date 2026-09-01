resource "aws_instance" "web" {
  ami           = "ami-xxxxxxxxxxxxxxxxx"
  instance_type = "t3.micro"

  tags = {
    Name = "terraform-demo-vm"
  }
}
