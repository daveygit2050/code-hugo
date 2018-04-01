resource "aws_s3_bucket" "code_bucket" {
  bucket = "${var.fqdn}-code"
}

resource "aws_iam_policy" "codepipeline_policy" {
  name        = "codepipeline-policy"
  path        = "/"
  description = "Policy used in trust relationship with CodePipeline"

  policy = "${file("../modules/pipeline/codepipeline-iam-policy.json")}"
}

resource "aws_iam_policy_attachment" "codepipeline_policy_attachment" {
  name       = "codepipeline-policy-attachment"
  policy_arn = "${aws_iam_policy.codepipeline_policy.arn}"
  roles      = ["${aws_iam_role.codepipeline_role.id}"]
}

resource "aws_iam_role" "codepipeline_role" {
  name                  = "codepipeline-role-${var.fqdn}"
  assume_role_policy    = "${file("../modules/pipeline/codepipeline-iam-trust.json")}"
  force_detach_policies = true
}

resource "aws_codepipeline" "pipeline" {
  name     = "${var.fqdn}"
  role_arn = "${aws_iam_role.codepipeline_role.arn}"

  artifact_store {
    location = "${aws_s3_bucket.code_bucket.bucket}"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source"]

      configuration {
        RepositoryName = "${var.fqdn}"
        BranchName     = "master"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source"]
      version         = "1"

      configuration {
        ProjectName = "${aws_codebuild_project.project.name}"
      }
    }
  }
}
