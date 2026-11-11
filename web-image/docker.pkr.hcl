source "docker" "container" {
  image  = "ubuntu:26.04"
  commit = true

  changes = [
    "EXPOSE 80",
    "LABEL org.opencontainers.image.version=${var.image_version}",
    "CMD [\"nginx\", \"-g\", \"daemon off;\"]",
  ]
}
