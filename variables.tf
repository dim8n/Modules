variable "region" {
  description = "Region location"
  type        = "string"
  default     = "eu-west-3"
}

variable "access_key" {
  description = "access_key"
  type        = "string"
  default     = "AKIAJECVMYQBGQWDS6YQ"
}

variable "secret_key" {
  description = "secret_key"
  type        = "string"
  default     = "95m67Btj6Mll1b1N+r14TlGnSZpeayhuJ7Udh7gf"
}

#variable "subnet_ids" {
#  description = "List of subnet IDs created in this network"
#  type        = "list"
#  default     = ["subnet-77cc7e3a","subnet-892e78e0","subnet-9f7f16e4"]
#}