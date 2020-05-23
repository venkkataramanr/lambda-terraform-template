variable "project_name" {
  type = string
}

variable "function_name" {
  type = string
}

variable "function_identifier" {
  type = string
}

variable "handler_name" {
  type = string
}

variable "tags" {
}


variable "environment" {
  type = object({
    variables = map(string)
  })
  default = null
}

variable "bucket" {
}

variable "tracing_config" {
  type = object({
    mode = string
  })
  default = null
}

variable "vpc_config" {
  type = object({
    security_group_ids = list(string)
    subnet_ids         = list(string)
  })
  default = null
}

variable "runtime" {

}

variable "timeout" {

}


variable "memory_size" {

}

variable "policy_document" {
  default = ""

}

