data "template_file" "bucket_policy" {
  template = "${file("../modules/infrastructure/s3-bucket-policy.json")}"

  vars {
    fqdn = "${var.fqdn}"
  }
}

resource "aws_s3_bucket" "site_bucket" {
  bucket = "www.${var.fqdn}"
  acl    = "public-read"
  policy = "${data.template_file.bucket_policy.rendered}"

  website {
    index_document = "index.html"
  }
}

resource "aws_s3_bucket" "redirect_bucket" {
  bucket = "${var.fqdn}"

  website {
    redirect_all_requests_to = "www.${var.fqdn}"
  }
}
