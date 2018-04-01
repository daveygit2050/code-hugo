provider "aws" {
  alias   = "${var.environment_name}"
  profile = "${var.environment_profile}"
  region  = "${var.environment_region}"
}

provider "aws" {
  region = "${var.state_region}"
}
