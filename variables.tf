variable "aws_region" {
  type    = string
  default = "us-west-2"
}

variable "cluster_name" {
  type    = string
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "node_instance_type" {
  type    = string
  default = "t3.medium"
}

variable "desired_capacity" {
  type    = number
  default = 2
}

variable "max_capacity" {
  type    = number
  default = 3
}

variable "min_capacity" {
  type    = number
  default = 1
}

# Add variable definitions here

variable "route53_zone_id" {
  description = "The ID of the Route53 hosted zone"
  type        = string
}

variable "email" {
  description = "The email address for notifications"
  type        = string
}


variable "issuer_name" {
  description = "The name of the certificate issuer"
  type        = string
}

variable "acme_server" {
  description = "The ACME server URL for Let's Encrypt"
  type        = string
}