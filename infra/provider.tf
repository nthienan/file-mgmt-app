provider "aws" {
  region = var.region
}

provider "aws" {
  # This provider will be used for provision WAF for CloudFront
  alias = "cfwaf"
  region = "us-east-1"
}
