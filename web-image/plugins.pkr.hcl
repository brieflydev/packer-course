packer {
  required_version = ">= 1.16.1"

  required_plugins {
    docker = {
      source  = "github.com/hashicorp/docker"
      version = "= 1.1.4"
    }

    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "= 1.8.2"
    }
  }
}