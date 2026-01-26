variable "az" {
  type        = string
  description = "availability zone name that project hosted"
}


variable "public_subnets" {
  type = map(string)
}

variable "private_subnets" {
  type = map(string)
}
# ec2 variables\

variable "key_pairs" {
  type = map(object({
    key_pair_name = string
    key_path      = string
  }))
  description = "key pair names and key locations"
}

variable "ec2_config" {
  type = map(object({
    instance_type = string
  }))
}

