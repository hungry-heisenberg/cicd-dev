resource "aws_ecr_repository" "lnp_aws_ecr_repository" {
  name                 = "lnp-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

output "ecr_repository_url" {
  value = aws_ecr_repository.lnp_aws_ecr_repository.repository_url
}