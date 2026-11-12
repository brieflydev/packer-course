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