data "amazon-ami" "ubuntu" {
  region      = var.aws_region
  owners      = ["099720109477"]
  most_recent = true

  filters = {
    name                = "ubuntu/images/hvm-ssd-gp3/ubuntu-resolute-26.04-amd64-server-*"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
}

source "amazon-ebs" "ami" {
  region        = var.aws_region
  source_ami    = data.amazon-ami.ubuntu.id
  instance_type = var.instance_type
  ssh_username  = "ubuntu"

  subnet_id                                 = var.subnet_id
  associate_public_ip_address               = true
  temporary_security_group_source_public_ip = true
  temporary_key_pair_type                   = "ed25519"

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  ami_name        = "${var.image_name}-${var.image_version}-${local.timestamp}"
  ami_description = "Hardened nginx web server ${var.image_version} on Ubuntu 26.04 LTS"
  ami_regions     = var.ami_regions
  imds_support    = "v2.0"

  tags = merge(local.common_tags, {
    Name        = "${var.image_name}-${var.image_version}"
    BaseAMI     = data.amazon-ami.ubuntu.id
    BaseAMIName = data.amazon-ami.ubuntu.name
  })

  snapshot_tags = merge(local.common_tags, {
    Name = "${var.image_name}-${var.image_version}"
  })

  run_tags = merge(local.common_tags, {
    Name = "packer-builder-${var.image_name}"
  })
}