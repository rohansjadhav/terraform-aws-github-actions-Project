variable "sg-id" {
    description = "security group ID for EC2 instance"
    type = string  
}

variable "subnet-id" {
    description = "Subnet ID for EC2 Instance"
    type = list(string)  
}

variable "ec2-names" {
    description = "ec2 names"
    type = list(string)
}