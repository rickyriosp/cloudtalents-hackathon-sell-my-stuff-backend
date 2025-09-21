terraform {
  backend "s3" {
    bucket       = "hackathon-sell-my-stuff-terraform-state-12hadf3"
    key          = "backend/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}