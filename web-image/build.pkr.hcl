build {
  name    = "nginx-web"
  sources = ["source.docker.container"]

  provisioner "shell" {
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
    ]
    scripts = [
      "${path.root}/scripts/install-nginx.sh",
    ]
  }

  post-processor "docker-tag" {
    repository = var.image_name
    tags       = [var.image_version]
  }
}