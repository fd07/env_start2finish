provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "ami-04ff98ccbfa41c9ad" ##Amazon Linux 2 AMI (HVM) - Kernel 5.10, SSD Volume Type
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorldInstance"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y httpd",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }
}

output "instance_public_ip" {
  value = aws_instance.web.public_ip
}

