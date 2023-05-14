resource "aws_instance" "jenkins-instance" {
  ami = var.AMI
  tags = {
    Name = "jenkins-instance"
  }
  instance_type = var.INSTANCE_TYPE
  subnet_id     = var.PUBLIC_SUBNET_ID
  # Attach the instance profile to the EC2 instance
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  vpc_security_group_ids = [aws_security_group.ssh-allowed.id]

  #key_name = var.KEY_PAIR
  key_name = aws_key_pair.jenkins_ec2_keypair.key_name

  user_data = var.USER_DATA
  connection {
    user        = var.EC2_USER
    private_key = file("${var.PRIVATE_KEY_PATH}")
  }
  depends_on = [
    aws_iam_role_policy_attachment.ECR_PullPush_role_policy_role,
    aws_key_pair.jenkins_ec2_keypair,
  ]

}


resource "aws_iam_policy" "ECR_PullPush_role_policy" {
  name = "Amazon_ECR_PullPush_role_policy"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:PutImage"
            ],
            "Resource": "*"
        }
    ]
}
POLICY
}

resource "aws_iam_policy" "EKS_Full_access" {
  name = "Amazon_EKS_Full_access"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "eks:*",
            "Resource": "*"
        }
    ]
}
POLICY
}


resource "aws_iam_role" "ElasticContainerRegistry_ECR_PullPush" {
  name = "ECR_PullPush_role"

  # The policy that grants an entity permission to assume the role.
  # The role that Amazon EKS will use to create AWS resources for Kubernetes clusters
  assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "EKS_Full_access_policy_role" {
  policy_arn = aws_iam_policy.EKS_Full_access.arn
  role       = aws_iam_role.ElasticContainerRegistry_ECR_PullPush.name
}

resource "aws_iam_role_policy_attachment" "ECR_PullPush_role_policy_role" {
  policy_arn = aws_iam_policy.ECR_PullPush_role_policy.arn
  role       = aws_iam_role.ElasticContainerRegistry_ECR_PullPush.name
}


resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.ElasticContainerRegistry_ECR_PullPush.name
}

resource "aws_security_group" "ssh-allowed" {
  vpc_id = var.MAIN_VPC_ID
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = [var.EGRESS_CIDR]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.INGRESS_CIDER]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.INGRESS_CIDER]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.INGRESS_CIDER]
  }
  tags = {
    Name = "ssh-allowed"
  }
}



resource "tls_private_key" "ansible_keypair" {
  algorithm   = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "jenkins_ec2_keypair" {
  key_name = "jenkins_ec2_keypair"
  public_key = tls_private_key.ansible_keypair.public_key_openssh
  depends_on = [ tls_private_key.ansible_keypair ]
}