terraform {
  backend "s3" {
    bucket = "dv-s3-mrefaat"
    key    = "terraform.tfstate"
    region = "eu-central-1"
    use_lockfile = true
  }
}
