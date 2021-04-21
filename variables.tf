
variable "availability_zones" {
  description = "Number of different AZs to use"
  type        = number
  default     = 3
}


variable "owner" {
  default = "sachinm"
}


variable "region" {
  default = "us-east-1"
}


variable "vpc_cidr" {
  default = "10.240.0.0/24"
}

variable "cluster_cidr" {
  default = "10.200.0.0/16"
}


variable "all_cidr" {
  default = "0.0.0.0/0"
}



variable "master_count" {
  default = 3
}


variable "worker_count" {
  default = 2
}


variable "etcd_count" {
  default = 3 
}

variable "lb_count" {
  default = 1
}

variable "centos" {
  default = "ami-06cf02a98a61f9f5e"
}


variable "ssh_public_key_path" {
  default = "~/.ssh/id_rsa.pub"
}


variable "centos_enable" {
  default = false
}
