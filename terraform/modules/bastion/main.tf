resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_id
  associate_public_ip_address = true
  key_name                    = var.key_name

  vpc_security_group_ids = [var.bastion_sg_id]

  user_data = <<-EOF
              #!/bin/bash
              set -euo pipefail
              exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1
              yum update -y
              yum install -y python3 python3-pip
              echo "Bastion bootstrap complete at $(date)"
              EOF

  tags = merge(var.tags, {
    Name        = var.name
    Role        = "bastion"
    Project     = "Monitoring Infrastructure"
    Environment = var.tags["Environment"]
  })
}

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}
