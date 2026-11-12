build {
  name = "nginx-web"

  sources = [
    "source.docker.container",
    "source.amazon-ebs.ami",
  ]

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
      "STATUS_PASSWORD=${var.status_password}",
    ]
    scripts = [
      "${path.root}/scripts/install-nginx.sh",
      "${path.root}/scripts/harden.sh",
    ]

    override = {
      ami = {
        execute_command = "chmod +x {{ .Path }}; sudo env {{ .Vars }} {{ .Path }}"
      }
    }
  }

  provisioner "shell" {
    only   = ["amazon-ebs.ami"]
    inline = ["systemctl is-enabled nginx"]
  }

  post-processor "docker-tag" {
    only       = ["docker.container"]
    repository = var.image_name
    tags       = [var.image_version]
  }

  post-processor "manifest" {
    output     = "packer-manifest.json"
    strip_path = true
    custom_data = {
      version = var.image_version
    }
  }
}