packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "= 1.8.2"
    }
  }
}

data "amazon-parameterstore" "ubuntu" {
  region = "eu-central-1"
  name   = "/aws/service/canonical/ubuntu/server/26.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
}

source "amazon-ebs" "from_filter" {
  region        = "eu-central-1"
  instance_type = "t3.micro"
  ssh_username  = "ubuntu"
  ami_name      = "example-from-filter-${formatdate("YYYYMMDD-hhmmss", timestamp())}"

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd-gp3/ubuntu-resolute-26.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    owners      = ["099720109477"]
    most_recent = true
  }
}

source "amazon-ebs" "from_ssm" {
  region        = "eu-central-1"
  instance_type = "t3.micro"
  ssh_username  = "ubuntu"
  ami_name      = "example-from-ssm-${formatdate("YYYYMMDD-hhmmss", timestamp())}"
  source_ami    = data.amazon-parameterstore.ubuntu.value
}

build {
  sources = [
    "source.amazon-ebs.from_filter",
    "source.amazon-ebs.from_ssm",
  ]
}