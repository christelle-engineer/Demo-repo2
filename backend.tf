
terraform {
backend  "s3" {
    bucket = "cbucket2022"
    key    = "state1/terraform.tfstate"
    region = "us-east-2"
  }

}