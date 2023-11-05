# main.auto.tfvars

terraform {
  cloud {
    organization = "bridgez"
    workspaces {
      name = "tf-azure"      
    }
  }
}
