variable "ami_id" {
  type    = string
  default = "ami-0c65adc9a5c1b5d7c"
}

variable "instance_type" {
  type    = string
  default = "t2.medium"
}

variable "az" {
  type    = string
  default = "us-west-2a"
}

variable "az2" {
  type    = string
  default = "us-west-2b"
}

/* variable "ecs_iam_role" {
  type = string
} */