module "infrastructure" {
  providers = {
    "aws" = "aws.${var.fqdn}"
  }

  source = "../modules/infrastructure"

  fqdn = "${var.fqdn}"
}

module "pipeline" {
  providers = {
    "aws" = "aws.${var.fqdn}"
  }

  source = "../modules/pipeline"

  account_id = "${var.environment_account_id}"
  fqdn       = "${var.fqdn}"
  owner      = "${var.owner}"
  region     = "${var.environment_region}"
}