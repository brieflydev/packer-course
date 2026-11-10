build {
  name    = "nginx-web"
  sources = ["source.docker.container"]

  provisioner "shell" {
    inline = [
      "apt-get update",
      "DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends nginx",
    ]
  }

  post-processor "docker-tag" {
    repository = "nginx-web"
    tags       = ["0.1.0"]
  }
}