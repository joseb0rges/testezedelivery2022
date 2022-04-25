resource "aws_iam_role" "ec2_role" {
  name = "ec2-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "policy" {
  name = "ec2_test-policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
       "s3:GetObject",
       "s3:GetObjectAcl",
       "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = "${aws_iam_role.ec2_role.name}"
  policy_arn = "${aws_iam_policy.policy.arn}"
}

resource "aws_iam_instance_profile" "test_profile" {
  name = "test_profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_network_interface" "main" {
  subnet_id = var.subnet_id
  security_groups = ["${aws_security_group.ec2-sg.id}"]
  private_ips = [var.private_ip] 
  tags = {
    "Name" = "IP address private"
  }
  
}

resource "aws_security_group" "ec2-sg" {
  name = "ec2_sg"
  vpc_id = var.vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block_priv]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "main" {
  ami           = var.ami
  instance_type = var.instance_type
  #subnet_id = var.subnet_id
  #key_name	= var.keyname
  
  
  network_interface {
     network_interface_id = "${aws_network_interface.main.id}"
     device_index = 0
  }

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 125
  }
  
  iam_instance_profile = aws_iam_instance_profile.test_profile.name
  user_data = file("${path.module}/ssm_install.sh")
  
}

