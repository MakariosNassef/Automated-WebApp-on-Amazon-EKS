output "INSTANCE_PUBLIC_IP" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.jenkins-instance.public_ip
}


output "PRIVATE_KEY_PEM" {
  value = tls_private_key.ansible_keypair.private_key_pem
  sensitive = true
  depends_on = [ aws_key_pair.jenkins_ec2_keypair ]
}