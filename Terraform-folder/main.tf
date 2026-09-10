terraform {
  required_version = ">= 1.0.0"
}

# This builds a simple local file to prove Terraform works perfectly
resource "local_file" "welcome_message" {
  filename = "${path.module}/hello-devops.txt"
  content  = "Welcome to your first ARM64 Terraform managed file!\n"
}
