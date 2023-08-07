locals {
  tags = {
    stage     = var.stage
    project   = var.project
    terraform = "true"
  }
  name_prefix  = "${var.stage}-${var.project}"
}
