variable "env" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "single_nat_gateway" {
  type = bool
}

variable "instance_type" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}
