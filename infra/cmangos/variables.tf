variable "region" {
  type    = string
  default = "us-west-2"
}

variable "profile" {
  type    = string
  default = "sandbox"
}


### VPC ###

variable "az_a" {
  type    = string
  default = "us-west-2a"
}

variable "az_b" {
  type    = string
  default = "us-west-2b"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "ssh_allowed_cidrs" {
  type = list(string)
}


### EC2 ###

variable "instance_type" {
  type    = string
  default = "m7i-flex.large"
}

variable "key_name" {
  type = string
}

variable "private_key_path" {
  type = string
}

variable "cmangos_bucket" {
  type = string
}

variable "config_version" {
  type = string
}

variable "client_key" {
  type = string
}

variable "extracted_key" {
  type = string
}

variable "root_volume_size_gb" {
  type    = number
  default = 50
}
