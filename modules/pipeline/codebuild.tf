data "template_file" "iam_policy" {
  template = "${file("codebuild-iam-policy.json")}"

  vars {
    account_id = "${var.account_id}"
    fqdn       = "${var.fqdn}"
    region     = "${var.region}"
  }
}

resource "aws_codebuild_project" "project" {
  name         = "${replace("${var.fqdn}", ".", "-")}"
  description  = "Build and deploy pipeline for the ${var.owner} website"
  service_role = "${aws_iam_role.codebuild_role.arn}"

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "jguyomard/hugo-builder"
    type         = "LINUX_CONTAINER"
  }

  source {
    type     = "CODECOMMIT"
    location = "https://git-codecommit.${var.region}.amazonaws.com/v1/repos/${var.fqdn}"
  }
}

resource "aws_iam_role" "codebuild_role" {
  name                  = "codebuild-role-${var.fqdn}"
  assume_role_policy    = "${file("codebuild-iam-trust.json")}"
  force_detach_policies = true
}

resource "aws_iam_policy" "codebuild_policy" {
  name        = "codebuild-policy"
  path        = "/service-role/"
  description = "Policy used in trust relationship with CodeBuild"

  policy = "${data.template_file.iam_policy.rendered}"
}

resource "aws_iam_policy_attachment" "codebuild_policy_attachment" {
  name       = "codebuild-policy-attachment"
  policy_arn = "${aws_iam_policy.codebuild_policy.arn}"
  roles      = ["${aws_iam_role.codebuild_role.id}"]
}
