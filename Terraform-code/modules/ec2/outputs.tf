output "ec2" {
    value = aws_instance.amazon-linux.*.id
  
}