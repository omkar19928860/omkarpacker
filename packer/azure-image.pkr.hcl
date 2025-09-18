source "azure-arm" "main" {
  use_azure_cli_auth = true

  location                          = "East US"
  managed_image_resource_group_name = "hclrg"
  managed_image_name                = "custom-ubuntu-image"

  os_type         = "Linux"
  image_publisher = "Canonical"
  image_offer     = "0001-com-ubuntu-server-jammy"
  image_sku       = "22_04-lts-gen2"
  vm_size         = "Standard_DS1_v2"

  azure_tags = {
    environment = "dev"
    created_by  = "azure-devops"
    approved    = "true"
  }

  build_resource_group_name     = "packer-temp-build-rg"
  temporary_resource_group_name = "packer-temp-temp-rg"
}

build {
  sources = ["source.azure-arm.main"]

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get upgrade -y",
      "sudo apt-get install -y nginx",
      "echo '<h1>Custom Image via Packer & Azure DevOps Federation</h1>' | sudo tee /var/www/html/index.html",
      "sudo rm -rf /var/lib/apt/lists/*"
    ]
  }
}
git

