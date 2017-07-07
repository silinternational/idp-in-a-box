/*
 * Create S3 bucket with appropriate permissions
 */
data "template_file" "bucket_policy" {
  template = "${file("${path.module}/bucket-policy.json")}"

  vars {
    bucket_name = "${var.ui_subdomain}.${var.cloudflare_domain}"
  }
}

resource "aws_s3_bucket" "ui" {
  bucket        = "${var.ui_subdomain}.${var.cloudflare_domain}"
  acl           = "public-read"
  policy        = "${data.template_file.bucket_policy.rendered}"
  force_destroy = true

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

/*
 * Create CloudFront distribution for SSL support but caching disabled, leave that to Cloudflare
 */
resource "aws_cloudfront_distribution" "ui" {
  count = 1

  origin {
    domain_name = "${aws_s3_bucket.ui.bucket_domain_name}"
    origin_id   = "ui-s3-origin"
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = ["${var.ui_subdomain}.${var.cloudflare_domain}"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "ui-s3-origin"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    /*
         * We dont want/need CloudFront to cache, we'll let CloudFlare handle that
         */
    viewer_protocol_policy = "redirect-to-https"

    min_ttl     = 0
    default_ttl = 0
    max_ttl     = 0
  }

  price_class = "PriceClass_All"

  tags {
    app_name = "${var.app_name}"
    app_env  = "${var.app_env}"
  }

  viewer_certificate {
    acm_certificate_arn      = "${var.wildcard_cert_arn}"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

/*
 * Give CI user access to s3 bucket and cloudfront
 */
resource "aws_iam_user_policy" "ci_ui" {
  name = "CloudFront-and-S3"
  user = "${var.cd_user_username}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1433518318000",
      "Effect": "Allow",
      "Action": [
        "cloudfront:CreateInvalidation"
      ],
      "Resource": [
        "${aws_cloudfront_distribution.ui.arn}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
          "${aws_s3_bucket.ui.arn}",
          "${aws_s3_bucket.ui.arn}/*"
      ]
    }
  ]
}
EOF
}

/*
 * Create Cloudflare DNS record
 */
resource "cloudflare_record" "uidns" {
  domain  = "${var.cloudflare_domain}"
  name    = "${var.ui_subdomain}"
  value   = "${aws_cloudfront_distribution.ui.domain_name}"
  type    = "CNAME"
  proxied = true
}
