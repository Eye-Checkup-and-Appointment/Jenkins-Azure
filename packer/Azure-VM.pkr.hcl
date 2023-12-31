packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 2"
    }
  }
}

source "azure-arm" "autogenerated_1" {
  azure_tags = {
    dept = "Engineering"
    task = "Image deployment"
  }
  //   client_id                         = "3efdc011-f93c-4001-8ae9-fe653b97eaf3"
  //   client_secret                     = "Fpi8Q~2xifsxWRQlo0PYJx2sLI3yCWnh2Spm4b7u"

  client_id                              = var.client_id
  client_secret                          = var.client_secret
  subscription_id                        = var.subscription_id


  image_offer                       = "0001-com-ubuntu-server-jammy"
  image_publisher                   = "canonical"
  image_sku                         = "22_04-lts"
  location                          = "East US"
  managed_image_name                = "Nginx_Package"
  managed_image_resource_group_name = "MyVMImageGroup"
  os_type                           = "Linux"




  vm_size = "Standard_DS2_v2"
}

build {
  sources = ["source.azure-arm.autogenerated_1"]

  // provisioner "shell" {
  //   execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
  //   inline          = ["apt-get update", "apt-get upgrade -y", "apt-get -y install nginx", "/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"]
  //   inline_shebang  = "/bin/sh -x"
  // }
  provisioner "file" {
    source      = "./nginx.conf"
    destination = "/tmp/nginx.conf"
  }

  provisioner "shell" {
    script = "./install_packages.sh"
  }

}