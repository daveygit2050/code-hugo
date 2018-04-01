terraform {
  backend "s3" {
    bucket = "goldsquare-state"
    key    = "terraform/code-hugo/test-site"
    region = "eu-west-1"
  }
}
