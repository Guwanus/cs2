resource "aws_ecr_repository" "repo" {
  name = "${var.project}-listener"
  image_scanning_configuration { scan_on_push = true }
  force_delete = true
}

locals {
  image_tag = "latest"
  image_uri = "${aws_ecr_repository.repo.repository_url}:${local.image_tag}"
}

# Build & push image using local-exec (requires Docker + AWS CLI)
resource "null_resource" "build_and_push" {
  triggers = {
    src_hash        = filesha256("${path.module}/app/app.py")
    dockerfile_hash = filesha256("${path.module}/app/Dockerfile")
  }

  provisioner "local-exec" {
    command = <<EOT
      aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${aws_ecr_repository.repo.repository_url}
      docker build -t ${aws_ecr_repository.repo.repository_url}:temp ${path.module}/app
      docker tag ${aws_ecr_repository.repo.repository_url}:temp ${local.image_uri}
      docker push ${local.image_uri}
    EOT
  }
}