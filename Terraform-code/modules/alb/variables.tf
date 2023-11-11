variable "sg-id" {
    description = "Security Group ID for ALB"
    type = string
}

variable "subnet-id" {
    description = "Subnet  for ALB"
    type = list(string)  
}

variable "vpc-id" {
  description = "VPC ID for Security Group"
  type = string  
}

variable "instances" {
    description = "Instance for Target Group Attachment"
    type = list(string)
}