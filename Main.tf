resource "aws_security_group" "Security-Group-Project" {
  name        = "Security-Group-Project"
  description = "Open 22,443,80,8080,9000"

  # Define a single ingress rule to allow traffic on all specified ports
  ingress = [
    for port in [22, 80, 443, 8080, 9000, 3000] : {
      description      = "TLS from VPC"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Security-Group-Project"
  }
}


resource "aws_instance" "web" {
  ami                    = "ami-0d97d7f07b25dd693"
  instance_type          = "m7i-flex.large"
  key_name               = "chitti"
  vpc_security_group_ids = [aws_security_group.Project-SG.id]
  user_data              = templatefile("./resource.sh", {})

  tags = {
    Name = "sravani-project"
  }
  root_block_device {
    volume_size = 30
  }
}
