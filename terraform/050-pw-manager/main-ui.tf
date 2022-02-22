/*
 * Create S3 bucket with appropriate permissions
 */
resource "aws_s3_bucket" "ui" {
  bucket        = local.ui_hostname
  force_destroy = true
}

resource "aws_s3_bucket_acl" "ui" {
  bucket = aws_s3_bucket.ui.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "ui" {
  bucket = "ui"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "AddPerm"
      Effect    = "Allow"
      Principal = "*"
      Action    = "s3:GetObject"
      Resource  = "arn:aws:s3:::${local.ui_hostname}/*"
    }]
  })
}

resource "aws_s3_bucket_website_configuration" "ui" {
  bucket = aws_s3_bucket.ui.id
  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

/*
 * Create CloudFront distribution for SSL support but caching disabled, leave that to Cloudflare
 */
resource "aws_cloudfront_distribution" "ui" {
  count = 1

  origin {
    domain_name = aws_s3_bucket.ui.bucket_domain_name
    origin_id   = "ui-s3-origin"
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = [local.ui_hostname]

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

    viewer_protocol_policy = "redirect-to-https"

    min_ttl     = 0
    default_ttl = 0
    max_ttl     = 0
  }

  price_class = "PriceClass_All"

  tags = {
    app_name = var.app_name
    app_env  = var.app_env
  }

  viewer_certificate {
    acm_certificate_arn      = var.wildcard_cert_arn
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
  user = var.cd_user_username

  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Sid    = "Stmt1433518318000"
          Effect = "Allow"
          Action = [
            "cloudfront:CreateInvalidation",
          ],
          Resource = [
            aws_cloudfront_distribution.ui[0].arn,
          ]
        },
        {
          Effect = "Allow"
          Action = [
            "s3:*",
          ],
          Resource = [
            aws_s3_bucket.ui.arn,
            "${aws_s3_bucket.ui.arn}/*",
          ]
        }
      ]
  })
}

/*
 * Create Cloudflare DNS record
 */
resource "cloudflare_record" "uidns" {
  zone_id = data.cloudflare_zones.domain.zones[0].id
  name    = var.ui_subdomain
  value   = aws_cloudfront_distribution.ui[0].domain_name
  type    = "CNAME"
  proxied = true
}

locals {
  ui_hostname = "${var.ui_subdomain}.${var.cloudflare_domain}"
}
