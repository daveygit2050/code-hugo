resource "aws_route53_zone" "zone" {
  name = "${var.fqdn}"
}

resource "aws_route53_record" "www-record" {
  zone_id = "${var.route53_zone_id}"
  name    = "www.${var.fqdn}"
  type    = "A"

  alias {
    name                   = "s3-website-${var.region}.amazonaws.com."
    zone_id                = "${var.route53_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "root-record" {
  zone_id = "${var.route53_zone_id}"
  name    = "${var.fqdn}"
  type    = "A"

  alias {
    name                   = "s3-website-${var.region}.amazonaws.com."
    zone_id                = "${var.route53_zone_id}"
    evaluate_target_health = false
  }
}
