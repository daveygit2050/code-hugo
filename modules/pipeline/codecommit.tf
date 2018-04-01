resource "aws_codecommit_repository" "repo" {
  repository_name = "${var.fqdn}"
  description     = "Code for the ${var.owner} website"
}
