variable "zone_name" {}
variable "record_name" {}
variable "record_target" {}

data "aws_route53_zone" "target" {
  name = var.zone_name
}

resource "aws_route53_record" "dns" {
  zone_id = data.aws_route53_zone.target.zone_id
  name    = var.record_name
  type    = "CNAME"
  ttl     = 300
  records = [var.record_target]
}