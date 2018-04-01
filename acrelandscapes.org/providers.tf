provider "aws" {
  alias   = "${var.fqdn}"
  profile = "${var.environment_profile}"
  region  = "${var.environment_region}"
}

provider "aws" {
  region = "${var.state_region}"
}
