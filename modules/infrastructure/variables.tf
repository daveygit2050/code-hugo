variable "fqdn" {}
variable "route53_zone_id" {}
variable "region" {}

variable "s3_zone_ids" {
  type = "map"

  default = {
    eu-west-1 = "Z1BKCTXD74EZPE"
    us-west-2 = "Z3BJ6K6RIION7M"
  }
}
