terraform {
  backend "s3" {
    bucket = "tfstates-demo"
    key    = "prod/vpc/terraform.tfstate"
    region = "us-west-2"
    dynamodb_table = "terraform-locking"
  }
}
