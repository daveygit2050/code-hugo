terraform {
  backend "s3" {
    bucket = "goldsquare-state"
    key    = "terraform/code-hugo/acrelandscapes.org"
    region = "eu-west-1"
  }
}
