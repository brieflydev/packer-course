build {
  name    = "nginx-web"
  sources = ["source.docker.container"]

  provisioner "file" {
    content = templatefile("${path.root}/files/index.html.pkrtpl", {
      version = var.image_version
      builder = source.type
    })
    destination = "/tmp/index.html"
  }

  provisioner "file" {
    source      = "${path.root}/files/nginx-site.conf"
    destination = "/tmp/nginx-site.conf"
  }

  provisioner "shell" {
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
    ]
    scripts = [
      "${path.root}/scripts/install-nginx.sh",
      "${path.root}/scripts/harden.sh",
    ]
  }

  post-processor "docker-tag" {
    repository = var.image_name
    tags       = [var.image_version]
  }
}