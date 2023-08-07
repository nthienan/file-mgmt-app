locals {
  cloudfront = {
    alb_origin_id = "alb"
  }
}

resource "aws_cloudfront_distribution" "main" {
  comment = "File Management Application"

  origin {
    origin_id   = local.cloudfront.alb_origin_id
    domain_name = aws_lb.main.dns_name
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled         = true
  is_ipv6_enabled = true

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    cache_policy_id  = aws_cloudfront_cache_policy.main.id
    target_origin_id = local.cloudfront.alb_origin_id

    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  price_class = "PriceClass_All"
  web_acl_id  = aws_wafv2_web_acl.main.arn
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = local.tags
}

resource "aws_cloudfront_cache_policy" "main" {
  name        = local.name_prefix
  comment     = "Cache policy for File Management App"
  default_ttl = 120
  max_ttl     = 300
  min_ttl     = 1
  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }
    headers_config {
      header_behavior = "none"
    }
    query_strings_config {
      query_string_behavior = "none"
    }
  }
}
