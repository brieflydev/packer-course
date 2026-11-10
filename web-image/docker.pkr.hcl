source "docker" "container" {
  image  = "ubuntu:26.04"
  commit = true

  changes = [
    "EXPOSE 80",
    "CMD [\"nginx\", \"-g\", \"daemon off;\"]",
  ]
}
